Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_APP_SECRET'], { strategy_class: OmniAuth::Strategies::Facebook, provider_ignores_state: true }
end