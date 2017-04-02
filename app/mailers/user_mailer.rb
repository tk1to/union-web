class UserMailer < ApplicationMailer
  default from: "学生団体Union"
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

  def ad_mail(email, name)
    @email = email
    @name  = name
    subject = "【新入生勧誘のお手伝いのご提案】学生団体Union"
    mail to: @email, subject: subject
  end
end
