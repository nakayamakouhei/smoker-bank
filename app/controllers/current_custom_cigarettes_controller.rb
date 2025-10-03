class CurrentCustomCigarettesController < ApplicationController
  before_action :authenticate_user!

  def update
    current_user.update!(
      current_custom_cigarette_id: params[:id],
      current_cigarette_id: nil # ← ここで通常銘柄をクリア
    )
    redirect_to authenticated_root_path, notice: "オリジナル銘柄を変更しました"
  end
end
