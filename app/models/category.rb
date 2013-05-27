class Category < ActiveRecord::Base
  attr_accessible :name

  self.per_page = 10
end
