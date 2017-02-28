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
      if current_user.new_messages_exist
      end
      if current_user.new_notifications_exist
        current_user.new_notifications_count = current_user.notifications.where(checked: false).count
        current_user.update_attribute(:new_notifications_exist, false)
      end
      if current_user.new_foots_exist
        current_user.new_foots_count = current_user.footed_prints.where(checked: false).count
        current_user.update_attribute(:new_foots_exist, false)
      end
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
