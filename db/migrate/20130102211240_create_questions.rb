class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :user
      t.belongs_to :answer
      t.string :reponse
      t.boolean :correct
      t.integer :amount

      t.timestamps
    end
    add_index :questions, :user_id
    add_index :questions, :answer_id
  end
end
