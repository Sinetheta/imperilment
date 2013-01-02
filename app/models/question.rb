class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer

  attr_accessible :amount, :correct, :reponse
end
