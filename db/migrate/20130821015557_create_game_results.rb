class CreateGameResults < ActiveRecord::Migration
  def change
    create_table :game_results do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :total
      t.integer :position
    end

    add_index :game_results, :game_id
    add_index :game_results, :user_id
    add_index :game_results, :position
  end
end
