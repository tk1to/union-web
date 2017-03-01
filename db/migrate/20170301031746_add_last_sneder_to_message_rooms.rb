class AddLastSnederToMessageRooms < ActiveRecord::Migration
  def change
    add_column :message_rooms, :last_sender_id, :integer
  end
end
