class CustomCigaretteLogsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.custom_cigarette_logs.create!(
      custom_cigarette_id: current_user.current_custom_cigarette_id,
      packs: params[:custom_cigarette_log][:packs],
      bought_date: Date.today
    )
    redirect_to authenticated_root_path, notice: "箱数をカウントしました"
  end

  def destroy
    @log = current_user.custom_cigarette_logs.find(params[:id])
    @log.destroy
    redirect_to histories_path(history_filter_params), notice: "履歴を削除しました"
  end

  private

  def history_filter_params
    params.permit(:sort, :start_date, :end_date, :page).to_h
  end
end
