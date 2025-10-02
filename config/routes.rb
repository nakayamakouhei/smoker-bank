Rails.application.routes.draw do
  devise_for :users

  # 未ログインユーザー（ヘルパーメソッド使用）
  unauthenticated do
    root "top#index"
  end

  # ログイン済みユーザー（ヘルパーメソッド使用）
  authenticated :user do
    root "home#index", as: :authenticated_root
  end

  resources :items, only: [ :index ]
  resources :smokes, only: [ :create ]
  resources :cigarettes, only: [] do
    collection do
      get :select
      patch :update_selection
    end
  end

  # 現在の銘柄記憶用コントローラールート
  resource :current_cigarette, only: [ :update ]
end
