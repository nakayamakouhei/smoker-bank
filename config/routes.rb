Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    # パスワード再設定メール送信完了ページ
    get "password_reset_sent", to: "users/passwords#sent", as: :password_reset_sent
    # パスワード変更完了ページ
    get "password_reset_done", to: "users/passwords#done", as: :password_reset_done

    # `/users` への直接アクセスは新規登録画面へリダイレクト
    get "/users", to: redirect("/users/sign_up")
  end

  get "terms", to: "pages#terms", as: :terms
  get "privacy", to: "pages#privacy", as: :privacy
  get "contact", to: "pages#contact", as: :contact
  post "send_contact", to: "pages#send_contact", as: :send_contact
  get "contact_complete", to: "pages#contact_complete", as: :contact_complete

  # 未ログインユーザー
  unauthenticated do
    root "top#index"
  end

  # ログイン済みユーザー
  authenticated :user do
    root "home#index", as: :authenticated_root
      # 通知時刻の更新
    resource :user, only: [] do
      patch :update_notification_time
    end
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
  resources :histories, only: [ :index ]
  resources :items, only: [ :index ]
  resource :profile, only: [ :edit, :update ]

  # プッシュ通知用
  resources :push_subscriptions, only: [ :create ] do
    collection do
      get :public_key
    end
  end

  # cron-job用
  namespace :internal do
    get "cron", to: "cron#run"
  end
end
