class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def facebook
    callback_from :facebook
  end

  private
    # def callback_from(provider)
    #   provider = provider.to_s
    #   @user = User.find_for_oauth(request.env['omniauth.auth'])
    #   if @user.persisted?
    #     cookies.permanent[:xxx_logined] = { value: @user.created_at }
    #     flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
    #     sign_in_and_redirect @user, event: :authentication
    #   else
    #     if provider == 'twitter'
    #       session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
    #     else
    #       session["devise.facebook_data"] = request.env["omniauth.auth"]
    #     end
    #     redirect_to new_user_registration_url
    #   end
    # end

    def callback_from(provider)
      provider = provider.to_s
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if @user.persisted?
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
        sign_in_and_redirect @user, event: :authentication
      else
        session["devise.#{provider}_data"] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
