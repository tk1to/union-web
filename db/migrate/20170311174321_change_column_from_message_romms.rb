class ChangeColumnFromMessageRomms < ActiveRecord::Migration
  def change
    change_column :message_rooms, :last_updated_time, :datetime
  end
end
