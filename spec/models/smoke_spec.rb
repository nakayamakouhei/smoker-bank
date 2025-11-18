# frozen_string_literal: true

require "rails_helper"

RSpec.describe Smoke, type: :model do
  describe "アソシエーション" do
    it "user に属する" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "cigarette に属する" do
      association = described_class.reflect_on_association(:cigarette)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "バリデーション" do
    it "全ての属性があれば有効" do
      expect(build(:smoke)).to be_valid
    end

    it "user がなければ無効" do
      smoke = build(:smoke, user: nil)

      expect(smoke).not_to be_valid
      expect(smoke.errors[:user]).to be_present
    end

    it "cigarette がなければ無効" do
      smoke = build(:smoke, cigarette: nil)

      expect(smoke).not_to be_valid
      expect(smoke.errors[:cigarette]).to be_present
    end

    it "packs がなければ無効" do
      smoke = build(:smoke, packs: nil)

      expect(smoke).not_to be_valid
      expect(smoke.errors[:packs]).to be_present
    end

    it "bought_date がなければ無効" do
      smoke = build(:smoke, bought_date: nil)

      expect(smoke).not_to be_valid
      expect(smoke.errors[:bought_date]).to be_present
    end
  end
end
