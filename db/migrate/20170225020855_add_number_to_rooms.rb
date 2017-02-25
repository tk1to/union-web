class AddNumberToRooms < ActiveRecord::Migration
  def change
    add_column :message_rooms, :creater_id, :integer
    add_column :message_rooms, :created_id, :integer
  end
end
