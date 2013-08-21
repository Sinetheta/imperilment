class GameResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def self.all_results
    self.select('user_id, sum(total) as total,
                      SUM(CASE WHEN position = 1 THEN 1 ELSE 0 END) as first,
                      SUM(CASE WHEN position = 2 THEN 1 ELSE 0 END) as second,
                      SUM(CASE WHEN position = 3 THEN 1 ELSE 0 END) as third'
                     )
      .group(:user_id)
      .order('first desc, second desc, third desc, total desc')
  end
end
