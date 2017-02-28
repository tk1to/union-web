class AddTypeToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :type, :integer
  end
end
