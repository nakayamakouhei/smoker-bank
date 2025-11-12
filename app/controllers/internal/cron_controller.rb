class Internal::CronController < ActionController::API
  skip_before_action :verify_authenticity_token

  def run
    token = params[:token].to_s
    unless ActiveSupport::SecurityUtils.secure_compare(token, ENV.fetch("CRON_SECRET", ""))
      return head :unauthorized
    end

    Rake::Task["notifications:send_daily"].reenable
    Rake::Task["notifications:send_daily"].invoke

    head :ok
  end
end
