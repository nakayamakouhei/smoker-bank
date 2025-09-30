Rails.application.routes.draw do
  devise_for :users

  # 未ログインユーザー
  unauthenticated do
    root "top#index"
  end

  # ログイン済みユーザー
  authenticated :user do
    root "home#index", as: :authenticated_root
  end
end