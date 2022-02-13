class Game < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :users, through: :answers
  has_many :game_results

  scope :locked, -> { where(locked: true) }

  before_update do
    calculate_result! if self.locked_changed? && locked
  end

  self.per_page = 10

  QUESTION_COUNT = 7

  QUESTION_VALUES = [200, 600, 1000, 400, 1200, 2000]

  QUESTION_REVEALS_DAY = [0, 0, 1, 1, 2, 3, 4]

  validate :ended_at_sunday

  def next
    @next ||= Game.order('games.ended_at ASC').where('games.ended_at > ?', ended_at).first
  end

  def prev
    @prev ||= Game.order('games.ended_at DESC').where('games.ended_at < ?', ended_at).first
  end

  def score(user)
    answers.to_a.sum(0) do |answer|
      question = answer.question_for(user)
      if !question || !question.closed? || (question.final? && !locked?)
        0
      else
        question.value
      end
    end
  end

  # The sum of all amounts from non-final, not-wrong questions for a given user.
  # This is the largest possible legal wager if future marking were to reveal no more mistakes.
  def max_wager(user)
    answers_table = Answer.arel_table
    questions_table = Question.arel_table
    answers.joins(
      answers_table.outer_join(questions_table).on(
        questions_table[:answer_id].eq(answers_table[:id]).and(questions_table[:user_id].eq(user.id))
      ).join_sources
    ).where(questions: { correct: [nil, true] }).sum(:amount)
  end

  def clamp_final_wager!(user)
    final = answers.find_by(amount: [nil, 0])&.question_for(user)
    if final&.amount
      amount = final.amount.clamp(0, max_wager(user))
      final.update(amount: amount) unless final.amount === amount
    end
  end

  def started_on
    answers.map(&:start_date).min
  end

  def date_range
    if started_on
      (started_on..ended_at)
    else
      []
    end
  end

  def all_answers
    Array.new(QUESTION_COUNT).each_with_index.map do |_nil, i|
      answers.order(:id)[i]
    end
  end

  def build_results
    position = 1
    results = []
    grouped_and_sorted_by_score.each do |total, users|
      users.each do |user|
        results << GameResult.new(user: user, game: self, total: total, position: position)
      end
      position += users.size
    end
    results
  end

  def calculate_result!
    GameResult.where(game_id: id).destroy_all
    build_results.each(&:save!)
    SlackNotification::GameFinalization.new(self).deliver if game_results.any?
  end

  def grouped_and_sorted_by_score
    users.uniq.sort_by do |user|
      -score(user)
    end.group_by do |user|
      score(user)
    end
  end

  def next_answer_amount
    QUESTION_VALUES[answers.count]
  end

  def next_answer_reveals_day
    QUESTION_REVEALS_DAY[answers.count]
  end

  def next_answer_start_date
    ended_at.beginning_of_week.advance(days: next_answer_reveals_day)
  end

  private

  def ended_at_sunday
    if ended_at.present? && ended_at.wday != 0
      errors.add(:ended_at, 'Must end on a Sunday')
    end
  end
end
