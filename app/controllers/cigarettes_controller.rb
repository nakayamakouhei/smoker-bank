class CigarettesController < ApplicationController
  before_action :authenticate_user!

  def select
    @cigarettes = Cigarette.order(:position, :id)
  end

  # routes.rbで呼び出し
  def update_selection
    if params[:current_cigarette_id].blank?
      redirect_to select_cigarettes_path, alert: "銘柄を選択してください"
    elsif current_user.update(current_cigarette_id: params[:current_cigarette_id])
      redirect_to authenticated_root_path, notice: "銘柄を変更しました"
    else
      redirect_to select_cigarettes_path, alert: "銘柄を変更できませんでした"
    end
  end
end
