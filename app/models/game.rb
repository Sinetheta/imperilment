class Game < ActiveRecord::Base
  has_many :answers
  has_many :game_results

  scope :locked, -> { where(locked: true) }

  self.per_page = 10

  def score(user)
    Question.joins(:answer => :game).where(user_id: user.id, 'games.id' => self.id).to_a.sum do |question|
      if question.answer.amount.nil? && !self.locked?
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

  def calculate_result!
    position = 1
    User.grouped_and_sorted_by_score(self).each do |total, users|
      users.each do |user|
        GameResult.create! user_id: user.id, game_id: self.id, total: total, position: position
      end
      position += users.size
    end
  end
end
