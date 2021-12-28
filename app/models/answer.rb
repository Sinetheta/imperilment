class Answer < ActiveRecord::Base
  scope :announceable, -> { where("start_date <= ? AND start_date >= ?",
                                 effective_date, announce_date) }

  belongs_to :game
  belongs_to :category

  has_many :questions
  has_many :users, through: :questions

  validates :game, :category, :start_date, presence: true
  validates :start_date, uniqueness: true

  def self.most_recent
    where('start_date <= ?', DateTime.now).order('start_date DESC').first
  end

  def self.last_answer
    order(:start_date).last
  end

  def self.announce_date
    today = Date.current

    today -= 1.day if today.monday?

    today
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
