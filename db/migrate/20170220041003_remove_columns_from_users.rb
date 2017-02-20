class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :remember_digest, :string
    remove_column :users, :activation_digest, :string
    remove_column :users, :activated, :bool
    remove_column :users, :activated_at, :datetime
  end
end
