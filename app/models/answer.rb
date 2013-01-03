class Answer < ActiveRecord::Base
  belongs_to :game
  belongs_to :category

  has_many :questions

  attr_accessible :amount, :answer, :correct_question, :start_date, :category_id

  validates :game, presence: true

  def self.most_recent
    self.where('start_date <= ?', DateTime.now).order('start_date DESC').limit(1).first
  end

  def prev
    Answer.where('updated_at < ?', updated_at).order('updated_at DESC').limit(1).first
  end

  def next
    Answer.where('updated_at > ?', updated_at).order('updated_at ASC').limit(1).first
  end

  def question_for(user)
    questions.where(user_id: user.id).first
  end

  def closed?
    !(correct_question.nil? || correct_question.empty?)
  end
end
