class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_notification_time
    # 通知時刻と last_notified_at の更新
    current_user.update!(
      notification_time: params[:notification_time],
      last_notified_at: nil
    )

    # Push購読情報が一緒に送られてきた場合に登録
    if params[:subscription].present?
      sub = current_user.push_subscriptions.find_or_initialize_by(endpoint: params[:subscription][:endpoint])
      keys = params[:subscription][:keys] || {}
      sub.update!(
        p256dh: keys[:p256dh],
        auth: keys[:auth]
      )
    end

    respond_to do |format|
      # ✅ JS（fetch）で呼ばれるため、JSONで返す
      format.json { render json: { message: "通知設定が更新されました" }, status: :ok }
      # ✅ 旧UI（フォーム送信など）の互換性も確保
      format.html { redirect_to authenticated_root_path, notice: "通知時刻を更新しました" }
    end

  rescue => e
    logger.error "通知設定更新エラー: #{e.message}"
    respond_to do |format|
      format.json { render json: { error: "保存に失敗しました" }, status: :unprocessable_entity }
      format.html { redirect_to authenticated_root_path, alert: "保存に失敗しました" }
    end
  end
end
