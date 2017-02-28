class AddBlogIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :blog_id, :integer
  end
end
