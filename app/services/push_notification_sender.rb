class PushNotificationSender
  def self.send(user, title:, body:)
    vapid = Rails.application.config.x.webpush_vapid

    puts "📢 Sending push notifications to #{user.email} (#{user.push_subscriptions.count} subscriptions)"

    user.push_subscriptions.find_each do |sub|
      begin
        WebPush.payload_send(
          message: { title: title, body: body }.to_json,
          endpoint: sub.endpoint,
          p256dh: sub.p256dh,
          auth: sub.auth,
          vapid: vapid
        )
      rescue WebPush::ResponseError => e
        status = e.response&.code
        if status.in?(%w[404 410])
          Rails.logger.info "🧹 Removing expired push subscription ##{sub.id} (status #{status})"
          sub.destroy
        else
          Rails.logger.error "❌ Failed to send to #{user.email} via subscription ##{sub.id}: #{e.message}"
        end
      rescue => e
        Rails.logger.error "❌ Unexpected push error for #{user.email} (subscription ##{sub.id}): #{e.message}"
      end
    end
  end
end
