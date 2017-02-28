class AddNewsToMessageRooms < ActiveRecord::Migration
  def change
    add_column :message_rooms, :new_messages_exist, :bool
    add_column :message_rooms, :new_messages_count, :integer
  end
end
