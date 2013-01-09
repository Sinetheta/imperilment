class Answer < ActiveRecord::Base
  belongs_to :game
  belongs_to :category

  has_many :questions

  attr_accessible :amount, :answer, :correct_question, :start_date, :category_id

  validates :game, presence: true

  def self.most_recent
    self.joins{game}.where{ |a|
      (a.start_date <= DateTime.now) &
      (a.game.locked == false)
    }.order(:start_date).reverse_order.first
  end

  def prev
    Answer.joins{game}.where{ |a|
      (a.updated_at < updated_at) &
      (a.game.locked == false)
    }.order(:updated_at).reverse_order.first
  end

  def next
    Answer.joins{game}.where{ |a|
      (a.updated_at > updated_at) &
      (a.game.locked == false)
    }.order(:updated_at).first
  end

  def question_for(user)
    return nil unless user
    questions.where(user_id: user.id).first
  end

  def closed?
    !(correct_question.nil? || correct_question.empty?)
  end
end
