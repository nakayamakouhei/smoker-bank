namespace :notifications do
  desc "Send scheduled push notifications to users"
  task send_daily: :environment do
    now = Time.current
    puts "⏰ Running notifications:send_daily at #{now.strftime('%H:%M')}"

    User.find_each do |user|
      next unless user.notification_time.present?

      notif_time = Time.zone.parse(user.notification_time.strftime("%H:%M"))
      diff = now - notif_time

      # 予定時刻を過ぎて3分以内なら通知
      if diff.between?(0, 3.minutes) &&
        (user.last_notified_at.nil? || user.last_notified_at.to_date < Date.current)
        begin
          PushNotificationSender.send(
            user,
            title: "今日の記録はつけましたか？",
            body: "#{user.name}さん、Smoker Bankで今日の喫煙をチェックしてみましょう"
          )
          user.update!(last_notified_at: Time.current)
          puts "✅ Sent notification to #{user.email} (設定: #{user.notification_time.strftime('%H:%M')}, 現在: #{now.strftime('%H:%M')})"
        rescue => e
          puts "❌ Failed to send to #{user.email}: #{e.message}"
        end
      end
    end

    puts "📬 Done sending notifications!"
  end
end
