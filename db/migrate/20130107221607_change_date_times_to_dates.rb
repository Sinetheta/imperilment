class ChangeDateTimesToDates < ActiveRecord::Migration
  def up
    change_column :answers, :start_date, :date
    change_column :games, :ended_at, :date
  end

  def down
    change_column :answers, :start_date, :datetime
    change_column :games, :ended_at, :datetime
  end
end
