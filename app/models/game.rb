class Game < ActiveRecord::Base
  has_many :answers
  has_many :users, through: :answers
  has_many :game_results

  scope :locked, -> { where(locked: true) }

  before_update do
    calculate_result! if self.locked_changed? && self.locked
  end

  self.per_page = 10

  def score(user)
    answers.to_a.sum(0) do |answer|
      question = answer.question_for(user)
      if !question || question.answer.amount.nil? && !self.locked?
        0
      else
        question.correct_question.blank? ? 0 : question.value
      end
    end
  end

  def started_on
    answers.order(:start_date).pluck(:start_date).first
  end

  def date_range
    (started_on..ended_at)
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
    GameResult.where(game_id: self.id).destroy_all
    build_results.each do |result|
      result.save!
    end
  end

  def grouped_and_sorted_by_score
    users.uniq.sort_by do |user|
      -self.score(user)
    end.group_by do |user|
      self.score(user)
    end
  end
end
