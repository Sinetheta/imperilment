class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  attr_accessible :amount, :correct, :response

  validate :unchecked_response

  scope :unchecked, where(correct: nil)
  scope :checked, where{correct != nil}

  scope :none, where('1 = 0')

  def checked?
    !correct.nil?
  end

  def unchecked_response
    if response_changed?
      errors.add(:response, "can't be updated once it has been checked!") unless correct.nil? || new_record?
    end
  end
end
