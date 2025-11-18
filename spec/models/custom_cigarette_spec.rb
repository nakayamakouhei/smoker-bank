# frozen_string_literal: true

require "rails_helper"

RSpec.describe CustomCigarette, type: :model do
  describe "アソシエーション" do
    it "user に属する" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "custom_cigarette_logs を多数持つ" do
      association = described_class.reflect_on_association(:custom_cigarette_logs)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "バリデーション" do
    it "全ての属性があれば有効" do
      expect(build(:custom_cigarette)).to be_valid
    end

    it "user がなければ無効" do
      custom_cigarette = build(:custom_cigarette, user: nil)

      expect(custom_cigarette).not_to be_valid
      expect(custom_cigarette.errors[:user]).to be_present
    end

    it "name がなければ無効" do
      custom_cigarette = build(:custom_cigarette, name: nil)

      expect(custom_cigarette).not_to be_valid
      expect(custom_cigarette.errors[:name]).to be_present
    end

    it "price がなければ無効" do
      custom_cigarette = build(:custom_cigarette, price: nil)

      expect(custom_cigarette).not_to be_valid
      expect(custom_cigarette.errors[:price]).to be_present
    end
  end
end
