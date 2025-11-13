class PagesController < ApplicationController
  skip_before_action :require_cigarette_selection

  def terms; end
  def privacy; end
  def contact
    @contact_form = ContactForm.new
  end

  def send_contact
    @contact_form = ContactForm.new(contact_form_params)

    unless @contact_form.valid?
      flash.now[:alert] = @contact_form.errors.full_messages.join("、")
      return render :contact, status: :unprocessable_entity
    end

    # SendGrid経由で送信
    SendgridMailer.contact_admin(@contact_form.name, @contact_form.email, @contact_form.message)
    SendgridMailer.contact_user(@contact_form.name, @contact_form.email)

    flash[:notice] = "お問い合わせを送信しました。"
    redirect_to contact_complete_path
  end

  def contact_complete; end

  private

  def contact_form_params
    params.require(:contact_form)
          .permit(:name, :email, :message)
  rescue ActionController::ParameterMissing
    {}
  end
end
