class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_notification_time
    if current_user.update(notification_time: params[:notification_time])
      redirect_to authenticated_root_path, notice: "通知時刻を更新しました！"
    else
      redirect_to authenticated_root_path, alert: "保存に失敗しました……"
    end
  end
end
