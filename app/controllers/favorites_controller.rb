class FavoritesController < ApplicationController

  before_action :authenticate_user!

  def create
    @circle = Circle.find(params[:circle_id])
    current_user.favorites.create(circle_id: @circle.id)
    @circle.memberships.each do |m|
      if m.chief? || m.admin?
        if !Notification.find_by(notification_type: 2, hold_user_id: m.id, circle_id: @circle.id, user_id: current_user.id)
          Notification.create(notification_type: 2, hold_user_id: m.id, circle_id: @circle.id, user_id: current_user.id)
          m.member.update_attribute(:new_notifications_exist, true)
          # UserMailer.notification_mail(nil, nil, nil).deliver_now
        end
      end
    end
    respond_to do |format|
      format.html {
        flash[:success] = "気になるしました！"
        redirect_to request.referer
      }
      format.js
    end
  end

  def destroy
    @circle = Circle.find(params[:circle_id])
    Favorite.find_by(circle_id: params[:circle_id], user_id: current_user.id).destroy
    respond_to do |format|
      format.html {
        flash[:success] = "気になるを解除しました"
        redirect_to request.referer
      }
      format.js
    end
  end
end
