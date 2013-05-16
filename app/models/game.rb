class Game < ActiveRecord::Base
  attr_accessible :ended_at, :locked

  has_many :answers

  scope :locked, -> { where(locked: true) }

  def score(user)
    Question.joins(:answer => :game).where(user_id: user.id, 'games.id' => self.id).sum do |question|
      question.correct_question.blank? ? 0 : question.value
    end
  end

  def started_on
    answers.order(:start_date).pluck(:start_date).first
  end

  def date_range
    (started_on..ended_at)
  end
end
