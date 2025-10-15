class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :require_cigarette_selection, raise: false
  prepend_before_action :require_no_authentication, only: [ :new, :create, :edit, :update ]
  before_action :prevent_browser_cache, only: [ :edit, :done ]

  # 再設定メール送信処理
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      redirect_to password_reset_sent_path
    else
      respond_with(resource)
    end
  end

  # パスワード再設定画面
  def edit
    # トークンが無効・期限切れならログイン画面へ
    self.resource = resource_class.with_reset_password_token(params[:reset_password_token])

    if resource.nil?
      redirect_to new_session_path(:user), alert: "このリンクはすでに無効です。再度お試しください。"
    else
      super
    end
  end

  # パスワード再設定メール送信後
  def sent; end

  # パスワード更新処理
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)

      # パスワード更新完了後はトークンが自動的に無効化される
      flash[:notice] = "パスワードが変更されました。新しいパスワードでログインしてください。"
      redirect_to password_reset_done_path
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  # パスワード変更完了画面
  def done; end

  private

  # 戻るボタン対策（キャッシュ禁止ヘッダー）
  def prevent_browser_cache
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
