class HistoriesController < ApplicationController
  def index
    smokes = current_user.smokes.includes(:cigarette)
    custom_logs = current_user.custom_cigarette_logs.includes(:custom_cigarette)
  
    # created_at で新しい順に並べる
    @histories = (smokes + custom_logs).sort_by(&:created_at).reverse
  end  
end
