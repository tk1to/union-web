class UserMailer < ApplicationMailer
  default from: "Union"
  def notification_mail(user, message_type, params)
    @user = user
    @message_type = message_type
    @params = params
    if message_type == "new_message"
      subject = "#{params.name}さんからメッセージが届いてます。"
    elsif message_type == "foots"
      subject = "Unionで足跡が付いています。"
    end
    mail to: @user.email, subject: subject
  end
end
