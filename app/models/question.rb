class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  validate :unchecked_response, :in_range?
  validates :answer_id, uniqueness: { scope: :user_id }

  validates :amount, numericality: { greater_than_or_equal: 0 }, if: ->(x) { x.answer.amount.nil? }

  scope :unchecked, -> { where(correct: nil) }
  scope :checked, -> { where{correct != nil} }

  delegate :correct_question, to: :answer

  def checked?
    !correct.nil?
  end

  def unchecked_response
    if response_changed?
      errors.add(:response, "can't be updated once it has been checked!") unless correct.nil? || new_record?
    end
  end

  def value
    if answer.amount
      correct? ? answer.amount : 0
    else
      case correct
      when true
        amount
      when false
        -amount
      else
        0
      end
    end
  end

  def in_range?
    unless amount.nil? || amount.between?(0, answer.game.score(user))
      errors.add(:amount, "is not within the acceptable range. Nice try!")
      false
    else
      true
    end
  end

  def status
    case correct
    when nil
      :unmarked
    when true
      :correct
    when false
      :incorrect
    end
  end
end
