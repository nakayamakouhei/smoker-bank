class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = current_user.push_subscriptions.find_or_initialize_by(
      endpoint: params[:endpoint]
    )

    subscription.update!(
      p256dh: params[:keys][:p256dh],
      auth: params[:keys][:auth]
    )

    head :ok
  end
end
