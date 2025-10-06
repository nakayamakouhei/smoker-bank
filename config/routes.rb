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

  resources :items, only: [ :index ]
  resources :smokes, only: [ :create, :destroy ]

  resources :cigarettes, only: [] do
    collection do
      get :select
      patch :update_selection
    end
  end

  resources :custom_cigarettes, only: [ :new, :create, :index ] do
    member do
      patch :select, to: "current_custom_cigarettes#update"
    end
  end

  # 現在の銘柄記憶用コントローラー
  resource :current_cigarette, only: [ :update ]

  resources :custom_cigarette_logs, only: [ :create, :destroy ]

  resources :histories, only: [:index]
end
