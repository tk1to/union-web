class UserMailer < ApplicationMailer
  default from: "Union運営局"
  def notification_mail(user, message_type, params)
    @user = user
    @message_type = message_type
    @params = params
    if message_type == "new_message"
      subject = "#{params.name}さんからメッセージが届いてます。"
    elsif message_type == "foots"
      subject = "Unionで足跡が付いています。"
    elsif message_type == "favorite"
      subject = "#{params.user_name}さんから#{params.circle_name}へ気になるが来ました。"
    elsif message_type = "entry"
      subject = "#{params.user_name}さんから#{params.circle_name}へメンバー申請が来ました。"
    elsif message_type = "contact"
      subject = "#{params.user_name}さんから#{params.circle_name}へお問い合わせが来ました。"
    end
    mail to: @user.email, subject: subject
  end

  def ad_mail(email, name)
    @email = email
    @name  = name
    subject = "【新入生募集のご提案】学生団体Union"
    mail to: @email, subject: subject
  end
end
