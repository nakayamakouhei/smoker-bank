class PagesController < ApplicationController
  skip_before_action :require_cigarette_selection

  def terms
  end

  def privacy
  end

  def contact
  end

  def send_contact
    flash.now[:notice] = "お問合せ内容を送信しました"
    render :contact, status: :ok
  end
end
