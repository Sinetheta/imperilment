class Answer < ActiveRecord::Base
  belongs_to :game
  belongs_to :category

  has_many :questions
  has_many :users, through: :questions

  validates :game_id, :category_id, :start_date, presence: true
  validates :start_date, uniqueness: true

  def self.most_recent
    self.joins{game}.where{ |a|
      (a.start_date <= DateTime.now) &
      (a.game.locked == false)
    }.order(:start_date).reverse_order.first
  end

  def self.on(date)
    self.where{ |a|
      a.start_date == date
    }.first
  end

  def self.next_free_date
    if last_answer
      last_answer.start_date.next
    else
      Date.today
    end
  end

  def self.last_answer
    self.order(:start_date).last
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
