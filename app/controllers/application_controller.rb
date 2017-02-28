class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :news_check

  # ログアウト後のリダイレクト
  def after_sign_out_path_for(resource)
    :root
  end

  def news_check
    if user_signed_in?
      user = current_user
      if user.new_messages_exist
        rooms = []
        user.message_rooms.each do |room|
          rooms << room if room.new_messages_exist
        end
        user.new_messages_count = 0
        rooms.each do |room|
          room.new_messages_count = room.messages.where(checked: false).count
          user.new_messages_count += room.new_messages_count
          room.new_messages_exist = false
          room.save
        end
        user.new_messages_exist = false
      end
      if user.new_notifications_exist
        user.new_notifications_count = user.notifications.where(checked: false).count
        user.new_notifications_exist = false
      end
      if user.new_foots_exist
        user.new_foots_count = user.footed_prints.where(checked: false).count
        user.new_foots_exist = false
      end
      user.save
    end
  end

  private

    # ユーザーのログインを確認する
    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "ログインしてください。"
    #     redirect_to login_url
    #   end
    # end
end
