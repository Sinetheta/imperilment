class Answer < ActiveRecord::Base
  scope :active, -> { where("start_date <= ?", effective_date) }

  belongs_to :game
  belongs_to :category

  has_many :questions
  has_many :users, through: :questions

  validates :game, :category, :start_date, presence: true
  validates :start_date, uniqueness: true

  def self.most_recent
    where('start_date <= ?', effective_date).order('start_date DESC').first
  end

  def self.next_free_date
    if last_answer
      last_answer.start_date.next
    else
      Date.today
    end
  end

  def self.last_answer
    order(:start_date).last
  end

  # Adjust date to include Saturday in Friday's release, and postpone Sunday until Monday's release
  def self.effective_date
    today = Time.zone.now

    today += 1.day if today.friday?
    today -= 1.day if today.sunday?

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

  def active?
    Answer.active.exists?(self.id)
  end
end
