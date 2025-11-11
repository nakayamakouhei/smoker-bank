class PushNotificationSender
  def self.send(user, title:, body:)
    vapid = Rails.application.config.x.webpush_vapid

    user.push_subscriptions.each do |sub|
      WebPush.payload_send(
        message: { title: title, body: body }.to_json,
        endpoint: sub.endpoint,
        p256dh: sub.p256dh,
        auth: sub.auth,
        vapid: vapid
      )
    end
  end
end
