class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  # 既存の銘柄とログ
  has_many :smokes, dependent: :destroy
  has_many :cigarettes, through: :smokes
  belongs_to :current_cigarette, class_name: "Cigarette", optional: true
  belongs_to :current_custom_cigarette, class_name: "CustomCigarette", optional: true

  # カスタム銘柄とログ
  has_many :custom_cigarettes, dependent: :destroy
  has_many :custom_cigarette_logs, dependent: :destroy

  # プッシュ通知用
  has_many :push_subscriptions, dependent: :destroy

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

  # 月毎の集計（指定年）
  def monthly_amounts(year: Time.zone.today.year)
    target_year = year.to_i
    start_time = Time.zone.local(target_year, 1, 1).beginning_of_day
    end_time = start_time.end_of_year

    range = start_time..end_time

    smokes_data = smokes.joins(:cigarette)
                        .where(created_at: range)
                        .group_by_month(:created_at, range:, format: "%Y-%m")
                        .sum("smokes.packs * cigarettes.price")

    custom_data = custom_cigarette_logs.joins(:custom_cigarette)
                                       .where(created_at: range)
                                       .group_by_month(:created_at, range:, format: "%Y-%m")
                                       .sum("custom_cigarette_logs.packs * custom_cigarettes.price")

    combined = smokes_data.merge(custom_data) { |_month, a, b| a + b }

    months = (0..11).map { |i| start_time.advance(months: i).strftime("%Y-%m") }
    months.index_with { |month| combined.fetch(month, 0) }
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
        password: Devise.friendly_token[0, 20],
        password_set: false
      )
    end
    user
  end

  # パスワード更新ロジック
  def update_with_optional_password(params)
    clean_params = params.except(:current_password)

    if provider == "google_oauth2" && !password_set
      success = update(clean_params)
      update(password_set: true) if success && clean_params[:password].present?
      return success
    end

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

  # Devise通知をSendGrid APIで処理
  def send_devise_notification(notification, *args)
    if notification == :reset_password_instructions
      token = args.first
      url_options = Rails.application.config.action_mailer.default_url_options || {}
      reset_link = Rails.application.routes.url_helpers.edit_user_password_url(
        { reset_password_token: token }.merge(url_options)
      )
      SendgridMailer.password_reset(email, reset_link)
    else
      super
    end
  end
end
