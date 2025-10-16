class ApplicationController < ActionController::Base
  # モダンブラウザ対応のみ許可（Rails標準の安全設定）
  allow_browser versions: :modern

  protect_from_forgery with: :exception

  # Deviseで追加パラメータを許可する
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ログイン済みのユーザーに対して、銘柄選択を強制
  before_action :require_cigarette_selection, if: :user_signed_in?

  # ビューでも使いたいメソッドを公開（ヘッダーなどで利用）
  helper_method :selected_any_cigarette?

  protected

  # Deviseのストロングパラメータ設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  # 銘柄が選ばれているか？を共通化
  def selected_any_cigarette?
    current_user.current_cigarette_id.present? ||
      current_user.current_custom_cigarette_id.present?
  end

  # 新規登録後のリダイレクト先
  def after_sign_up_path_for(resource)
    select_cigarettes_path
  end

  # 🔹 ログイン後のリダイレクト先
  def after_sign_in_path_for(resource)
    if selected_any_cigarette?
      authenticated_root_path  # 銘柄選択済み → ホームへ
    else
      select_cigarettes_path   # 未選択 → 銘柄選択画面へ
    end
  end

  # 銘柄未選択ユーザーを選択画面へ誘導する
  def require_cigarette_selection
    # Devise関連・銘柄選択関連ページは除外
    return if controller_name.in?(%w[sessions registrations passwords])
    return if controller_name.in?(%w[cigarettes custom_cigarettes])
    return if action_name.in?(%w[select update_selection new create index])

    # どちらの銘柄も未選択なら、選択画面へ強制リダイレクト
    unless selected_any_cigarette?
      redirect_to select_cigarettes_path, alert: "まずは銘柄を選択してください。"
    end
  end
end
