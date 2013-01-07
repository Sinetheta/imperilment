class Game < ActiveRecord::Base
  attr_accessible :ended_at

  has_many :answers

  def score(user)
    Question.joins(:answer => :game).where(user_id: user.id, 'games.id' => self.id).sum do |question|
      question.value
    end
  end

  def started_on
    answers.order(:start_date).pluck(:start_date).first
  end

  def date_range
    (started_on..ended_at)
  end
end
