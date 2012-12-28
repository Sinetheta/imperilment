class Answer < ActiveRecord::Base
  belongs_to :game
  belongs_to :category
  attr_accessible :amount, :answer, :correct_question, :start_date, :category_id

  validates :game, presence: true
end
