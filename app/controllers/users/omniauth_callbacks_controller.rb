class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def facebook
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    )

    remember_me(user)

    sign_in_and_redirect user, event: :authentication
  end

  def failure
    redirect_to root_path
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
