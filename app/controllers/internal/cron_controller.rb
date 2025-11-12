require "rake"

class Internal::CronController < ActionController::API
  before_action :load_rake_tasks_once

  def run
    token = params[:token].to_s
    unless ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch("CRON_SECRET", ""))
      return head :unauthorized
    end

    # Rakeタスクを1回だけ読み込んだ上で、呼び出す
    Rake::Task["notifications:send_daily"].reenable
    Rake::Task["notifications:send_daily"].invoke

    head :ok
  end

  private

  def load_rake_tasks_once
    return if defined?(@@tasks_loaded) && @@tasks_loaded
    Rails.application.load_tasks
    @@tasks_loaded = true
  end
end
