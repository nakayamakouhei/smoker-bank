class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # userモデルの合計金額メソッド
    @total_amount = current_user.total_amount
    # userモデルの合計箱数メソッド
    @total_packs = current_user.total_packs
    # たばこの銘柄一覧取得
    @cigarettes = Cigarette.all
  end  
end
