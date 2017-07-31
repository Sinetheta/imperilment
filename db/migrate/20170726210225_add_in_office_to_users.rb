class AddInOfficeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :in_office, :boolean, {null: false, default: false}
  end
end
