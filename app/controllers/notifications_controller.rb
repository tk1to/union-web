class NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @notifications = Notification.where(hold_user_id: current_user).order("created_at DESC")

    current_user.update_attributes(new_notifications_count: 0, new_notifications_exist: false)
    @notifications.where(checked: false).each do |notification|
      notification.update_attribute(:checked, true)
    end
  end
end
