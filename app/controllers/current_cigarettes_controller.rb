class CurrentCigarettesController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.update!(current_cigarette_id: params[:current_cigarette_id])
    redirect_to authenticated_root_path, notice: "銘柄を変更しました"
  end
end
