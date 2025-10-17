# config/initializers/seed_loader.rb
# Render Free プランでも安全に動作する seed 自動投入ロジック

if Rails.env.production?
  begin
    # まだ Cigarette が1件もなければ seed 投入
    if Cigarette.count.zero?
      Rails.logger.info "[SeedLoader] No cigarettes found. Running deploy:seed..."
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task["deploy:seed"].invoke
      Rails.logger.info "[SeedLoader] Seed completed successfully!"
    else
      Rails.logger.info "[SeedLoader] Cigarettes already present. Skipping seed."
    end
  rescue => e
    Rails.logger.error "[SeedLoader] Seed load failed: #{e.message}"
  end
end
