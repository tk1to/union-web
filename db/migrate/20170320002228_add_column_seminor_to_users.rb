class AddColumnSeminorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seminar, :string
  end
end
