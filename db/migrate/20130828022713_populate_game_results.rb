class PopulateGameResults < ActiveRecord::Migration
  def up
    Game.all.each(&:calculate_result!)
  end

  def down
    GameResult.destroy_all
  end
end
