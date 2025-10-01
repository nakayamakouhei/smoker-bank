class SmokesController < ApplicationController
  def create
    # 新しいsmokeレコードを登録
    # smoke_paramsのハッシュとbought_dateのハッシュを合体させて作る
    current_user.smokes.create!(smoke_params.merge(bought_date: Date.today))

    # 合計を再計算（Userモデルのメソッドを流用）
    @total_amount = current_user.total_amount
    @total_packs  = current_user.total_packs

    # リクエストヘッダ(Accept)の内容に応じた分岐処理
    respond_to do |format|
      # Turbo Streamリクエストの場合
      # → create.turbo_stream.erb を自動で探して描画（部分更新用）
      format.turbo_stream
      # 普通のHTMLリクエストの場合
      # → /home#index (authenticated_root_path) にリダイレクト（全体更新）
      format.html { redirect_to authenticated_root_path }
    end
  end

  private

  def smoke_params
    params.require(:smoke).permit(:packs, :cigarette_id)
  end
end
