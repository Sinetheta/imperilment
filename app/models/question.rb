class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  attr_accessible :amount, :correct, :reponse

  scope :unchecked, where(correct: nil)
end
