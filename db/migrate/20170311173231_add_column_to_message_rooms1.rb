class AddColumnToMessageRooms1 < ActiveRecord::Migration
  def change
    add_column :message_rooms, :last_updated_time, :timestamp
  end
end
