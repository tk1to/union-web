class AddNewsExistToUsers < ActiveRecord::Migration
  def change
    add_column :users, :news_exist, :bool, default: false
    add_column :users, :new_messages_count, :integer
    add_column :users, :new_notifications_count, :integer
    add_column :users, :new_foots_count, :integer
  end
end
