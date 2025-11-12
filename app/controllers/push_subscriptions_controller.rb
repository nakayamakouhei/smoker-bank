class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: :public_key
  protect_from_forgery with: :null_session, only: :create

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(endpoint: subscription_params[:endpoint])
    subscription.update!(
      p256dh: subscription_params.dig(:keys, :p256dh),
      auth: subscription_params.dig(:keys, :auth)
    )
    head :ok
  end

  def public_key
    public_key = Rails.application.config.x.webpush_vapid[:public_key]
    if public_key.present?
      render json: { publicKey: public_key }
    else
      render json: { error: "VAPID公開鍵が設定されていません" }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:endpoint, keys: [:p256dh, :auth])
  end
end
