class HistoriesController < ApplicationController
  def index
    smokes = current_user.smokes.includes(:cigarette)
    custom_logs = current_user.custom_cigarette_logs.includes(:custom_cigarette)
    @histories = smokes + custom_logs

    # 並び替え
    @histories =
      case params[:sort]
      when "date_asc"
        @histories.sort_by(&:bought_date)
      when "name_asc"
        @histories.sort_by { |log| log.is_a?(Smoke) ? log.cigarette.name : log.custom_cigarette.name }
      when "price_desc"
        @histories.sort_by { |log| log.is_a?(Smoke) ? log.cigarette.price : log.custom_cigarette.price }.reverse
      when "price_asc"
        @histories.sort_by { |log| log.is_a?(Smoke) ? log.cigarette.price : log.custom_cigarette.price }
      else
        @histories.sort_by(&:bought_date).reverse
      end

    # 日付フィルタ
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @histories.select! { |h| h.bought_date.between?(start_date, end_date) }
    end

    # 合計はページネーション前の全件を対象に集計
    all_histories = @histories.dup
    @total_amount = all_histories.sum do |log|
      log.is_a?(Smoke) ? log.cigarette.price * log.packs : log.custom_cigarette.price * log.packs
    end
    @total_packs = all_histories.sum(&:packs)

    # ✅ ページネーションは最後に適用
    @histories = Kaminari.paginate_array(all_histories).page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
