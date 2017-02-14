class AddCollegeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :college, :string
    add_column :users, :department, :string
  end
end
