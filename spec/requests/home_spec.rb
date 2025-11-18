# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home", type: :request do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette, price: 500, name: "Alpha") }
  let(:custom_cigarette) { create(:custom_cigarette, user:, price: 700, name: "Bravo") }

  before do
    sign_in user
    user.update!(current_cigarette: cigarette)
    create(:smoke, user:, cigarette:, packs: 2, bought_date: Date.new(2024, 1, 10))
    create(:custom_cigarette_log, user:, custom_cigarette:, packs: 1, bought_date: Date.new(2024, 1, 15))
  end

  it "合計金額・箱数・最近の履歴が表示される" do
    get authenticated_root_path

    doc = Nokogiri::HTML.parse(response.body)
    amount_text = doc.at_css("#total_amount")&.text&.gsub(/[,\s円]/, "")
    packs_text = doc.at_css("#total_packs")&.text&.gsub(/[,\s箱]/, "")

    expect(amount_text).to eq("1700")
    expect(packs_text).to eq("3")
    expect(response.body).to include("Alpha").and include("Bravo")
    expect(response).to have_http_status(:ok)
  end
end
