# frozen_string_literal: true

require "rails_helper"

RSpec.describe HistorySummary do
  let(:user) { create(:user) }
  let(:cigar_a) { create(:cigarette, name: "Alpha", price: 500, position: 1, manufacturer: "M1") }
  let(:cigar_b) { create(:cigarette, name: "Beta", price: 700, position: 2, manufacturer: "M1") }
  let(:custom) { create(:custom_cigarette, user:, name: "Custom", price: 900) }

  before do
    create(:smoke, user:, cigarette: cigar_a, packs: 1, bought_date: Date.new(2024, 1, 10))
    create(:smoke, user:, cigarette: cigar_b, packs: 2, bought_date: Date.new(2024, 2, 10))
    create(:custom_cigarette_log, user:, custom_cigarette: custom, packs: 3, bought_date: Date.new(2024, 1, 20))
  end

  it "デフォルトで日付降順に並べて総計を計算する" do
    summary = described_class.new(user:, params: {})
    histories = summary.filtered_histories
    expect(histories.first.bought_date).to eq(Date.new(2024, 2, 10))
    expect(summary.filtered_total_packs).to eq(6)
    expect(summary.filtered_total_amount).to eq(1 * 500 + 2 * 700 + 3 * 900)
  end

  it "日付範囲を指定するとその期間だけを返す" do
    summary = described_class.new(user:, params: { start_date: "2024-01-01", end_date: "2024-01-31" })
    expect(summary.filtered_histories.map(&:bought_date)).to all(be_between(Date.new(2024, 1, 1), Date.new(2024, 1, 31)))
    expect(summary.filtered_total_packs).to eq(4)
  end

  it "price_desc で金額が高い順に並べる" do
    summary = described_class.new(user:, params: { sort: "price_desc" })
    prices = summary.filtered_histories.map { |h| summary.send(:log_price, h) }
    expect(prices).to eq(prices.sort.reverse)
  end

  it "name_asc で名前順に並べる" do
    summary = described_class.new(user:, params: { sort: "name_asc" })
    names = summary.filtered_histories.map { |h| summary.send(:log_name, h) }
    expect(names).to eq(names.sort)
  end
end
