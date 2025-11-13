class SmokesController < ApplicationController
  include HistoryDeletable
  
  def create
    # 箱数登録を押した時の挙動
    current_user.smokes.create!(
      packs: smoke_params[:packs],
      cigarette_id: current_user.current_cigarette_id,
      bought_date: Date.today
    )

    # 合計を再計算（Userモデルのメソッドを流用）
    @total_amount = current_user.total_amount
    @total_packs  = current_user.total_packs

    redirect_to authenticated_root_path, notice: "箱数をカウントしました"
  end

  def destroy
    @smoke = current_user.smokes.find(params[:id])
    @smoke.destroy
    respond_to_destroy(@smoke)
  end

  private

  def smoke_params
    params.require(:smoke).permit(:packs, :cigarette_id)
  end

  def history_filter_params
    params.permit(:sort, :start_date, :end_date, :page).to_h
  end
end
