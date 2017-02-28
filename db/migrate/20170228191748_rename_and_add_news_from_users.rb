class RenameAndAddNewsFromUsers < ActiveRecord::Migration
  def change
    rename_column :users, :news_exist, :new_messages_exist
    add_column :users, :new_notifications_exist, :bool
    add_column :users, :new_foots_exist, :bool
  end
end
