class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  attr_accessible :amount, :correct, :response

  validate :unchecked_response

  scope :unchecked, where(correct: nil)

  def unchecked_response
    if response_changed?
      errors.add(:response, "can't be updated once it has been checked!") unless correct.nil?
    end
  end
end
