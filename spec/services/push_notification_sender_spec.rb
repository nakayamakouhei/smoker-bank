# frozen_string_literal: true

require "rails_helper"

RSpec.describe PushNotificationSender do
  let(:user) { create(:user) }
  let!(:subscription) { create(:push_subscription, user:) }

  before do
    allow(Rails.application.config).to receive_message_chain(:x, :webpush_vapid).and_return({ public_key: "pub", private_key: "priv", subject: "mailto:test@example.com" })
  end

  it "全ての購読にペイロードを送信する" do
    expect(WebPush).to receive(:payload_send).with(hash_including(endpoint: subscription.endpoint)).and_return(true)

    described_class.send(user, title: "Title", body: "Body")
  end

  it "404/410 のとき購読を削除する" do
    response = instance_double(Net::HTTPResponse, code: "410", body: "gone")
    allow(WebPush).to receive(:payload_send).and_raise(WebPush::ResponseError.new(response, subscription.endpoint))

    expect { described_class.send(user, title: "Title", body: "Body") }.to change { user.push_subscriptions.count }.by(-1)
  end

  it "その他エラーでは削除せずログ出力する" do
    allow(WebPush).to receive(:payload_send).and_raise(StandardError.new("boom"))

    expect { described_class.send(user, title: "Title", body: "Body") }.not_to change { user.push_subscriptions.count }
  end
end
