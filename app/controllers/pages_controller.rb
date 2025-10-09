class PagesController < ApplicationController
  skip_before_action :require_cigarette_selection

  def terms; end
  def privacy; end
  def contact; end

  def send_contact
    name = params[:name]
    email = params[:email]
    message = params[:message]

    # 管理者（あなた）宛てに送信
    ContactMailer.send_contact(name, email, message).deliver_now

    # 送信者（ユーザー）宛てに自動返信
    ContactMailer.reply_to_user(name, email).deliver_now

    redirect_to contact_complete_path
  end

  def contact_complete; end
end
