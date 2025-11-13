module HistoryDeletable
  extend ActiveSupport::Concern

  def respond_to_destroy(record)
    respond_to do |format|
      format.turbo_stream do

        # Home の最近3件の <turbo-frame> から削除された場合
        if request.headers["Turbo-Frame"] == "home_recent_histories"
          render_home_recent_histories

        else
          # histories/index （ページ本体）から削除された場合
          render turbo_stream: turbo_stream.remove(record)
        end
      end

      # Turbo無効時のフォールバック
      format.html { redirect_to histories_path, notice: "履歴を削除しました" }
    end
  end

  private

  # Home の最近3件をリロードする
  def render_home_recent_histories
    render turbo_stream: turbo_stream.replace(
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
