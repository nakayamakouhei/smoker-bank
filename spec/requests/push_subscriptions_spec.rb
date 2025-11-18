# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PushSubscriptions", type: :request do
  let(:user) { create(:user) }
  let(:subscription_params) do
    {
      subscription: {
        endpoint: "https://example.com/endpoint",
        keys: { p256dh: "p-key", auth: "auth-key" }
      }
    }
  end

  before do
    allow(Rails.application.config).to receive_message_chain(:x, :webpush_vapid).and_return({ public_key: "public", private_key: "private" })
  end

  describe "POST /push_subscriptions" do
    before { sign_in user }

    it "プッシュ購読を新規登録する" do
      expect {
        post push_subscriptions_path, params: subscription_params, as: :json
      }.to change { user.push_subscriptions.count }.by(1)

      expect(response).to have_http_status(:ok)
      sub = user.push_subscriptions.last
      expect(sub.p256dh).to eq("p-key")
      expect(sub.auth).to eq("auth-key")
    end

    it "同じ endpoint の購読を更新する" do
      create(:push_subscription, user:, endpoint: subscription_params[:subscription][:endpoint], p256dh: "old")

      expect {
        post push_subscriptions_path, params: subscription_params, as: :json
      }.not_to change { user.push_subscriptions.count }

      expect(user.push_subscriptions.last.p256dh).to eq("p-key")
    end
  end

  describe "GET /push_subscriptions/public_key" do
    it "設定があれば公開鍵を返す" do
      get public_key_push_subscriptions_path

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ "publicKey" => "public" })
    end

    it "設定が無ければエラーを返す" do
      allow(Rails.application.config).to receive_message_chain(:x, :webpush_vapid).and_return({ public_key: nil })

      get public_key_push_subscriptions_path

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to include("error")
    end
  end
end
