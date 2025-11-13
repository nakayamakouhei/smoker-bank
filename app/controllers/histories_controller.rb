class HistoriesController < ApplicationController
  def index
    summary = HistorySummary.new(user: current_user, params: params)
    @histories = summary.paginated_histories
    @total_amount = summary.filtered_total_amount
    @total_packs = summary.filtered_total_packs

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
