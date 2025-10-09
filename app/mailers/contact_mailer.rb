class ContactMailer < ApplicationMailer
  default to: "paradinatu@gmail.com", from: "no-reply@smokerbank.com"

  def send_contact(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(subject: "【Smoker Bank】お問い合わせが届きました")
  end

  def reply_to_user(name, email)
    @name = name
    mail(
      to: email,
      subject: "【Smoker Bank】お問い合わせありがとうございます"
    )
  end
end
