class CustomCigaretteLogsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.custom_cigarette_logs.create!(
      custom_cigarette_id: current_user.current_custom_cigarette_id,
      packs: params[:custom_cigarette_log][:packs],
      bought_date: Date.today
    )
    redirect_to authenticated_root_path, notice: "オリジナル銘柄を登録しました"
  end

  def destroy
    @log = current_user.custom_cigarette_logs.find(params[:id])
    @log.destroy
    redirect_to histories_path, notice: "履歴を削除しました"
  end
end
