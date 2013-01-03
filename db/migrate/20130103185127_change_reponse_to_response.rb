class ChangeReponseToResponse < ActiveRecord::Migration
  def change
    rename_column :questions, :reponse, :response
  end
end
