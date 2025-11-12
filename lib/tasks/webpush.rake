namespace :webpush do
  desc "Send test WebPush notification to all subscriptions"
  task send_test: :environment do
    message = "✅ WebPush test message!"

    PushSubscription.find_each do |sub|
      begin
        Webpush.payload_send(
          endpoint: sub.endpoint,
          message: message,
          p256dh: sub.p256dh,
          auth: sub.auth,
          vapid: {
            public_key: ENV["VAPID_PUBLIC_KEY"],
            private_key: ENV["VAPID_PRIVATE_KEY"],
            subject: "mailto:paradinatu@gmail.com"
          },
          ttl: 24 * 60 * 60
        )

        puts "✅ Sent to #{sub.endpoint}"
      rescue => e
        puts "❌ Failed to send to #{sub.endpoint}"
        puts "   Error: #{e.message}"
      end
    end

    puts "✅ Web Push test finished!"
  end
end
