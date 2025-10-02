class CustomCigarettesController < ApplicationController
  before_action :authenticate_user!

  def index
    # 自分の銘柄だけ取得
    @custom_cigarettes = current_user.custom_cigarettes.order(created_at: :desc)
  end

  def new
    @custom_cigarette = current_user.custom_cigarettes.new
  end

  def create
    @custom_cigarette = current_user.custom_cigarettes.new(custom_cigarette_params)
    if @custom_cigarette.save
      redirect_to custom_cigarettes_path, notice: "オリジナル銘柄を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def custom_cigarette_params
    params.require(:custom_cigarette).permit(:name, :price)
  end
end
