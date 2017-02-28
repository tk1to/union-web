class RelationshipsController < ApplicationController

  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    if Notification.find_by(notification_type: 0, hold_user_id: @user.id, user_id: current_user.id).nil?
      @user.notifications.create(notification_type: 0, user_id: current_user.id)
      @user.update_attribute(:new_notifications_exist, true)
    end

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end