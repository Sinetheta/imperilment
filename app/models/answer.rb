class Answer < ActiveRecord::Base
  belongs_to :game
  belongs_to :category

  has_many :questions
  has_many :users, through: :questions

  validates :game_id, :category_id, :start_date, presence: true
  validates :start_date, uniqueness: true

  def self.most_recent
    self.where('start_date <= ?', DateTime.now).order('start_date DESC').first
  end

  def self.on(date)
    self.where(start_date: date).first
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

  def questions_by_user_id
    @questions_by_user ||= Hash[questions.map do |q|
      [q.user_id, q]
    end]
  end
  private :questions_by_user_id

  def question_for(user)
    return nil unless user
    questions_by_user_id[user.id]
  end

  def closed?
    !(correct_question.nil? || correct_question.empty?)
  end

  def final?
    !amount
  end
end
