class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # userモデルの合計金額メソッド
    @total_amount = current_user.total_amount
    # userモデルの合計箱数メソッド
    @total_packs = current_user.total_packs
    # たばこの銘柄一覧取得
    @cigarettes = Cigarette.all
    @current_year = Time.zone.today.year
    requested_year = params[:year].presence&.to_i
    @selected_year = requested_year || @current_year

    @previous_year = @selected_year - 1
    @next_year = @selected_year + 1

    @monthly_amounts = current_user.monthly_amounts(year: @selected_year)

    smokes = current_user.smokes.includes(:cigarette)
    custom_logs = current_user.custom_cigarette_logs.includes(:custom_cigarette)

    # 履歴を結合して購入日降順で並べ替え
    @recent_histories = (smokes + custom_logs)
      .sort_by(&:bought_date)
      .reverse
      .first(3)
  end
end
