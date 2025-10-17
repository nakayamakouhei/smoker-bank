# lib/tasks/seed_deploy.rake
namespace :deploy do
  desc "Run db:seed in production environment"
  task seed: :environment do
    puts "🚀 Running db:seed in production..."
    Rake::Task["db:seed"].invoke
    puts "✅ Done seeding!"
  end
end
