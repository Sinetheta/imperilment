class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :game
      t.belongs_to :category
      t.text :correct_question
      t.text :answer
      t.integer :amount
      t.datetime :start_date

      t.timestamps
    end
    add_index :answers, :game_id
    add_index :answers, :category_id
  end
end
