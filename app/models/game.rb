class Game < ActiveRecord::Base
  attr_accessible :ended_at

  has_many :answers

  def score(user)
    Question.joins(:answer => :game).where(user_id: user.id, 'games.id' => self.id, correct: true).sum { |question| question.answer.amount }
  end
end
