# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendgridMailer do
  describe ".contact_admin" do
    it "管理者宛メールを送信する" do
      expect(described_class).to receive(:send_email).with(hash_including(
        to: "paradinatu@gmail.com",
        subject: include("お問い合わせが届きました"),
        body: include("名前: 太郎"),
      ))

      described_class.contact_admin("太郎", "taro@example.com", "こんにちは")
    end
  end

  describe ".contact_user" do
    it "ユーザー宛メールを送信する" do
      expect(described_class).to receive(:send_email).with(hash_including(
        to: "taro@example.com",
        subject: include("お問い合わせありがとうございます"),
        body: include("太郎 様"),
      ))

      described_class.contact_user("太郎", "taro@example.com")
    end
  end

  describe ".password_reset" do
    it "リセットリンクを含むメールを送信する" do
      expect(described_class).to receive(:send_email).with(hash_including(
        to: "taro@example.com",
        subject: include("パスワード再設定"),
        body: include("https://example.com/reset"),
      ))

      described_class.password_reset("taro@example.com", "https://example.com/reset")
    end
  end
end
