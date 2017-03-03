class AddEntryingIdtoUsers < ActiveRecord::Migration
  def change
    add_column :users, :joining_id, :integer
  end
end
