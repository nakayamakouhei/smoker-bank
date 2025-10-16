class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # 既存の銘柄とログ
  has_many :smokes, dependent: :destroy
  has_many :cigarettes, through: :smokes
  belongs_to :current_cigarette, class_name: "Cigarette", optional: true
  belongs_to :current_custom_cigarette, class_name: "CustomCigarette", optional: true

  # カスタム銘柄とログ
  has_many :custom_cigarettes, dependent: :destroy
  has_many :custom_cigarette_logs, dependent: :destroy

  validates :name, presence: true

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

  def self.from_omniauth(auth)
    # すでにGoogleでログイン済みのユーザーを探す
    user = find_by(email: auth.info.email)
  
    if user
      # 既存ユーザーがいたら、そのユーザーにGoogle情報を紐づけ
      user.update(
        name: auth.info.name,
        provider: auth.provider,
        uid: auth.uid
      )
    else
      # 新規ユーザーとして登録
      user = create(
        name: auth.info.name,
        email: auth.info.email,
        provider: auth.provider,
        uid: auth.uid,
        password: Devise.friendly_token[0, 20] # 仮パスワード
      )
    end
    user
  end
end
