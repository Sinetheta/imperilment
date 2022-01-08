class Game < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :users, through: :answers
  has_many :game_results

  scope :locked, -> { where(locked: true) }

  before_update do
    calculate_result! if self.locked_changed? && locked
  end

  self.per_page = 10

  QUESTION_COUNT = 7

  QUESTION_VALUES = [200, 600, 1000, 400, 1200, 2000]

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

  # The sum of all amounts from non-final, not-wrong questions for a given user.
  # This is the largest possible legal wager if future marking were to reveal no more mistakes.
  def max_wager(user)
    answers.left_outer_joins(:questions).where(
      questions: { id: nil }
    ).or(
      answers.where(
        questions: { correct: [true, nil] }
      )
    ).sum(:amount)
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
    Array.new(QUESTION_COUNT).each_with_index.map do |_nil, i|
      answers.order(:id)[i]
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

  def next_answer_amount
    QUESTION_VALUES[answers.count]
  end

  def next_answer_start_date
    ended_at - (6 - answers.count).days
  end
end
