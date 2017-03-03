class RenameJoiningIdFromUsers < ActiveRecord::Migration
  def change
    rename_column :users, :joining_id, :joining_circle_id
  end
end
