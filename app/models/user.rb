class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 既存の銘柄とログ
  has_many :smokes, dependent: :destroy
  has_many :cigarettes, through: :smokes

  # カスタム銘柄とログ
  has_many :custom_cigarettes, dependent: :destroy
  has_many :custom_cigarette_logs, dependent: :destroy

  def total_amount
    # 既存銘柄の合計
    smokes_total = smokes.joins(:cigarette)
                         .sum("smokes.packs * cigarettes.price")
    # カスタム銘柄の合計
    custom_total = custom_cigarette_logs.joins(:custom_cigarette)
                                        .sum("custom_cigarette_logs.packs * custom_cigarettes.price")
    # トータル
    smokes_total + custom_total
  end

  def total_packs
    # 既存銘柄とカスタム銘柄の箱数合計
    smokes.sum(:packs) + custom_cigarette_logs.sum(:packs)
  end
end
