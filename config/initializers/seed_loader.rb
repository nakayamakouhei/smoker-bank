# config/initializers/seed_loader.rb
if Rails.env.production?
  flag_path = Rails.root.join("tmp", "seed_loaded")

  unless File.exist?(flag_path)
    Thread.new do
      Rails.logger.info "[SeedLoader] Waiting for full Rails boot..."

      # Railsアプリ全体が完全に初期化されるまで待機
      sleep 10

      max_retries = 10
      retry_count = 0

      begin
        # モデルを明示的にロード
        Rails.application.eager_load!

        # DB接続確認
        ActiveRecord::Base.connection.execute("SELECT 1")
        Rails.logger.info "[SeedLoader] ✅ DB connection confirmed."

        # seeds.rb 実行
        load(Rails.root.join("db", "seeds.rb"))

        File.write(flag_path, Time.current.to_s)
        Rails.logger.info "[SeedLoader] 🎉 Seed data loaded successfully!"

      rescue => e
        retry_count += 1
        Rails.logger.error "[SeedLoader] ⚠️ Seed load failed (#{retry_count}/10): #{e.message}"

        if retry_count < max_retries
          sleep 5
          retry
        else
          Rails.logger.error "[SeedLoader] ❌ Gave up after #{max_retries} attempts."
        end
      end
    end
  else
    Rails.logger.info "[SeedLoader] 🌿 Seed already loaded — skipping."
  end
end
