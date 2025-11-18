# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "POST /send_contact" do
    let(:valid_params) do
      { contact_form: { name: "太郎", email: "taro@example.com", message: "こんにちは" } }
    end

    it "不備があれば422で再表示" do
      post send_contact_path, params: { contact_form: { name: "", email: "bad", message: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("お問い合わせ")
    end

    it "正しい入力でメールを送信し完了画面へ" do
      allow(SendgridMailer).to receive(:contact_admin).and_return(true)
      allow(SendgridMailer).to receive(:contact_user).and_return(true)

      post send_contact_path, params: valid_params

      expect(SendgridMailer).to have_received(:contact_admin).with("太郎", "taro@example.com", "こんにちは")
      expect(SendgridMailer).to have_received(:contact_user).with("太郎", "taro@example.com")
      expect(response).to redirect_to(contact_complete_path)
      expect(flash[:notice]).to include("お問い合わせを送信しました")
    end
  end
end
