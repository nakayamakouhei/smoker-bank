# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/user/update_notification_time", type: :request do
  let(:user) { create(:user) }
  let!(:cigarette) { create(:cigarette) }

  before do
    user.update!(current_cigarette: cigarette)
    sign_in user
  end

  it "通知時刻を更新し購読情報も保存する" do
    patch update_notification_time_user_path,
          params: {
            notification_time: "08:30",
            subscription: {
              endpoint: "https://example.com/endpoint",
              keys: { p256dh: "p-key", auth: "auth-key" }
            }
          },
          as: :json

    expect(response).to have_http_status(:ok)
    expect(user.reload.notification_time.strftime("%H:%M")).to eq("08:30")
    expect(user.push_subscriptions.count).to eq(1)
    sub = user.push_subscriptions.last
    expect(sub.p256dh).to eq("p-key")
    expect(sub.auth).to eq("auth-key")
  end

  it "HTML でリクエストした場合はリダイレクトする" do
    patch update_notification_time_user_path, params: { notification_time: "09:00" }

    expect(response).to redirect_to(authenticated_root_path)
    follow_redirect!
    expect(response.body).to include("通知時刻を更新しました")
  end
end
