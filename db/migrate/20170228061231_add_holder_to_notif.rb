class AddHolderToNotif < ActiveRecord::Migration
  def change
    add_column :notifications, :hold_user_id, :integer
  end
end
