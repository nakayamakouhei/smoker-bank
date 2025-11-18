# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cigarette, type: :model do
  describe "アソシエーション" do
    it "smokes を多数持つ" do
      association = described_class.reflect_on_association(:smokes)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "smokes を経由して users を多数持つ" do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:smokes)
    end
  end

  describe "バリデーション" do
    it "全ての属性があれば有効" do
      expect(build(:cigarette)).to be_valid
    end

    it "name がなければ無効" do
      cigarette = build(:cigarette, name: nil)

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:name]).to be_present
    end

    it "manufacturer がなければ無効" do
      cigarette = build(:cigarette, manufacturer: nil)

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:manufacturer]).to be_present
    end

    it "position がなければ無効" do
      cigarette = build(:cigarette, position: nil)

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:position]).to be_present
    end

    it "price がなければ無効" do
      cigarette = build(:cigarette, price: nil)

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:price]).to be_present
    end

    it "name が重複すると無効" do
      create(:cigarette, name: "Same Name")
      cigarette = build(:cigarette, name: "Same Name")

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:name]).to be_present
    end

    it "同一 manufacturer で position が重複すると無効" do
      create(:cigarette, manufacturer: "Maker", position: 1)
      cigarette = build(:cigarette, manufacturer: "Maker", position: 1)

      expect(cigarette).not_to be_valid
      expect(cigarette.errors[:position]).to be_present
    end
  end
end
