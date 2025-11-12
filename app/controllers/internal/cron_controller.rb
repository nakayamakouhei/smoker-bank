require "rake"

class Internal::CronController < ActionController::API

  def run
    token = params[:token].to_s
    unless ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch("CRON_SECRET", ""))
      return head :unauthorized
    end

    Rails.application.load_tasks

    Rake::Task["notifications:send_daily"].reenable
    Rake::Task["notifications:send_daily"].invoke

    head :ok
  end
end
