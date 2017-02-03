class RenameActionToWantToDoFromUsers < ActiveRecord::Migration
  def change
    rename_column :users, :action, :want_to_do
  end
end
