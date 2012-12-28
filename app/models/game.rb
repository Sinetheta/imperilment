class Game < ActiveRecord::Base
  attr_accessible :ended_at

  has_many :answers
end
