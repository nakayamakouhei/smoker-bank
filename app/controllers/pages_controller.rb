class PagesController < ApplicationController
  skip_before_action :require_cigarette_selection

  def terms; end
  def privacy; end
  def contact; end

  def send_contact
    name = params[:name]
    email = params[:email]
    message = params[:message]
  
    # SendGrid経由で送信
    SendgridMailer.contact_admin(name, email, message)
    SendgridMailer.contact_user(name, email)
  
    redirect_to contact_complete_path
  end

  def contact_complete; end
end
