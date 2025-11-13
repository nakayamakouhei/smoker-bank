module HistoryDeletable
  extend ActiveSupport::Concern

  def respond_to_destroy(record)
    home_total_amount = current_user.total_amount
    home_total_packs  = current_user.total_packs

    filtered_summary = HistorySummary.new(user: current_user, params: history_filter_params)
    histories_total_amount = filtered_summary.filtered_total_amount
    histories_total_packs  = filtered_summary.filtered_total_packs

    respond_to do |format|
      format.turbo_stream do
        streams = []

        if request.headers["Turbo-Frame"] == "home_recent_histories"
          streams << home_recent_histories_stream
        else
          streams << turbo_stream.remove(record)
        end

        streams << turbo_stream.replace(
          "total_amount",
          partial: "home/total_amount",
          locals: { total_amount: home_total_amount }
        )
        streams << turbo_stream.replace(
          "total_packs",
          partial: "home/total_packs",
          locals: { total_packs: home_total_packs }
        )

        streams << turbo_stream.replace(
          "histories_totals",
          partial: "histories/totals",
          locals: { total_amount: histories_total_amount, total_packs: histories_total_packs }
        )

        render turbo_stream: streams
      end

      format.html { redirect_to histories_path, notice: "履歴を削除しました" }
    end
  end

  private

  def home_recent_histories_stream
    turbo_stream.replace(
      "home_recent_histories",
      partial: "home/recent_histories",
      locals: { recent_histories: latest_three_histories }
    )
  end

  # 最新3件の取得
  def latest_three_histories
    (current_user.smokes + current_user.custom_cigarette_logs)
      .sort_by(&:bought_date)
      .reverse
      .first(3)
  end
end
