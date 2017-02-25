class AddIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :message_room_id, :integer
  end
end
