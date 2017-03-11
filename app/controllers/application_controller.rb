class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :news_check, :only_sp

  # ログイン後のリダイレクト
  def after_sign_in_path_for(resource)
    :top
  end
  # ログアウト後のリダイレクト
  def after_sign_out_path_for(resource)
    :root
  end

  def only_sp
    if !session[:only_sp]
      ua = request.env["HTTP_USER_AGENT"]
      unless (ua.include?('Mobile') || ua.include?('Android'))
        session[:only_sp] = true
        @only_sp = true
      end
    end
  end
  def news_check
    if user_signed_in?
      user = current_user
      if user.new_messages_exist
        rooms = user.message_rooms.where(new_messages_exist: true).where.not(last_sender_id: user.id)
        user.new_messages_count = 0
        rooms.each do |room|
          room.new_messages_count = room.messages.where(checked: false).count
          user.new_messages_count += room.new_messages_count
          room.save
        end
        user.new_messages_exist = false
      end
      if user.new_notifications_exist
        user.new_notifications_count = user.notifications.where(checked: false).count
      end
      if user.new_foots_exist
        user.new_foots_count = user.footed_prints.where(checked: false).count
      end
      user.save
    end
  end

end
