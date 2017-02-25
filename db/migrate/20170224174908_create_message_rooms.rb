class CreateMessageRooms < ActiveRecord::Migration
  def change
    create_table :message_rooms do |t|

      t.timestamps null: false
    end
  end
end
