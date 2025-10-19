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

  # 合計金額・本数
  def total_amount
    smokes_total = smokes.joins(:cigarette)
                         .sum("smokes.packs * cigarettes.price")
    custom_total = custom_cigarette_logs.joins(:custom_cigarette)
                                        .sum("custom_cigarette_logs.packs * custom_cigarettes.price")
    smokes_total + custom_total
  end

  def total_packs
    smokes.sum(:packs) + custom_cigarette_logs.sum(:packs)
  end

  # Googleログイン
  def self.from_omniauth(auth)
    user = find_by(email: auth.info.email)

    if user
      user.update(
        name: auth.info.name,
        provider: auth.provider,
        uid: auth.uid
      )
    else
      user = create(
        name: auth.info.name,
        email: auth.info.email,
        provider: auth.provider,
        uid: auth.uid,
        password: Devise.friendly_token[0, 20], # 仮パスワード
        password_set: false                     # ←★ ここを追加
      )
    end
    user
  end

  # パスワード更新ロジック
  def update_with_optional_password(params)
    # current_password はDBにないので除外
    clean_params = params.except(:current_password)
  
    # Googleログインのみ、かつパス未設定
    if provider == "google_oauth2" && !password_set
      success = update(clean_params)
      update(password_set: true) if success && clean_params[:password].present?
      return success
    end
  
    # 通常ユーザー or Google（パス設定済）
    if clean_params[:password].present?
      if valid_password?(params[:current_password])
        success = update(clean_params)
        update(password_set: true) if success
        success
      else
        errors.add(:current_password, "が正しくありません")
        false
      end
    else
      update(clean_params.except(:password, :password_confirmation))
    end
  end
end
