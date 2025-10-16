# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Googleからのコールバックを受け取る
  def google_oauth2
    # OmniAuthで取得した情報
    auth = request.env["omniauth.auth"]

    # Userモデル側でユーザー検索 or 作成
    @user = User.from_omniauth(auth)

    if @user.persisted?
      # 成功時はログインしてホームにリダイレクト
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = "Googleアカウントでログインしました。" if is_navigational_format?
    else
      # 保存に失敗した場合（例: バリデーションエラーなど）
      session["devise.google_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "Google認証に失敗しました。"
    end
  end

  # OmniAuthが失敗したとき
  def failure
    redirect_to root_path, alert: "Googleログインに失敗しました。"
  end
end
