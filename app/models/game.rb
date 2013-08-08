class Game < ActiveRecord::Base
  has_many :answers

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
end
