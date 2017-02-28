class AddInfromToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :user_id, :integer
    add_column :notifications, :circle_id, :integer
    add_column :notifications, :content, :string
  end
end
