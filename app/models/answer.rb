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

  def prev
    Answer.where('answers.updated_at < ?', updated_at).includes(:game).where("games.locked" => false).order('answers.updated_at DESC').first
  end

  def next
    Answer.where('answers.updated_at > ?', updated_at).includes(:game).where("games.locked" => false).order('answers.updated_at ASC').first
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

  def question_for(user)
    return nil unless user
    questions.detect{|q| q.user_id == user.id }
  end

  def closed?
    !(correct_question.nil? || correct_question.empty?)
  end
end
