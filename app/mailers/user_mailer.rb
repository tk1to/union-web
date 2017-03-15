class UserMailer < ApplicationMailer
  default from: "Union"
  def notification_mail(user, message_type, params)
    @user = user
    @message_type = message_type
    @params = params
    mail to: @user.email
  end
end
