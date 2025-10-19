# frozen_string_literal: true

Devise.setup do |config|
  # The secret key used by Devise.
  # config.secret_key = 'your_secret_key_here'

  # ==> Controller configuration
  # config.parent_controller = 'DeviseController'

  # ==> Mailer Configuration
  # --------------------------------------------
  # SendGrid経由でメールを送信する設定（Render無料プラン対応）
  # --------------------------------------------
  # 送信元アドレス（表示用）
  config.mailer_sender = "no-reply@smokerbank.com"

  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  require "devise/orm/active_record"

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 12

  # ==> Configuration for :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :recoverable
  config.reset_password_within = 6.hours

  # ==> Configuration for :confirmable
  config.reconfirmable = true

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :timeoutable
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # config.lock_strategy = :failed_attempts
  # config.unlock_strategy = :both
  # config.maximum_attempts = 20
  # config.unlock_in = 1.hour
  # config.last_attempt_warning = true

  # ==> Configuration for :encryptable
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # config.scoped_views = false
  # config.default_scope = :user
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # config.navigational_formats = ['*/*', :html, :turbo_stream]
  config.sign_out_via = :delete

  # ==> OmniAuth（Google認証）
  config.omniauth :google_oauth2,
    ENV["GOOGLE_CLIENT_ID"],
    ENV["GOOGLE_CLIENT_SECRET"],
    {
      scope: "userinfo.email,userinfo.profile",
      access_type: "offline",
      prompt: "select_account"
    }

  # OmniAuthルートの接頭辞
  config.omniauth_path_prefix = "/users/auth"

  # ==> Warden configuration
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Hotwire/Turbo configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
