class NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @notifications = Notification.where(hold_user_id: current_user).order("created_at DESC")
  end
end
