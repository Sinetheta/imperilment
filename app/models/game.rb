class Game < ActiveRecord::Base
  has_many :answers
  has_many :users, through: :answers
  has_many :game_results

  scope :locked, -> { where(locked: true) }

  before_update do
    calculate_result! if self.locked_changed? && locked
  end

  self.per_page = 10

  def next
    @next ||= Game.order('games.ended_at ASC').where('games.ended_at > ?', ended_at).first
  end

  def prev
    @prev ||= Game.order('games.ended_at DESC').where('games.ended_at < ?', ended_at).first
  end

  def score(user)
    answers.to_a.sum(0) do |answer|
      question = answer.question_for(user)
      if !question || !question.closed? || (question.final? && !locked?)
        0
      else
        question.value
      end
    end
  end

  def started_on
    answers.map(&:start_date).min
  end

  def date_range
    if started_on
      (started_on..ended_at)
    else
      []
    end
  end

  def all_answers
    @all_answers ||= begin
      as = answers.to_a
      date_range.map do |date|
        as.detect { |a| a.start_date == date }
      end
    end
  end

  def build_results
    position = 1
    results = []
    grouped_and_sorted_by_score.each do |total, users|
      users.each do |user|
        results << GameResult.new(user: user, game: self, total: total, position: position)
      end
      position += users.size
    end
    results
  end

  def calculate_result!
    GameResult.where(game_id: id).destroy_all
    build_results.each(&:save!)
    SlackNotification::GameFinalization.new(self).deliver if game_results.any?
  end

  def grouped_and_sorted_by_score
    users.uniq.sort_by do |user|
      -score(user)
    end.group_by do |user|
      score(user)
    end
  end
end
