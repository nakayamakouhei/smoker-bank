# frozen_string_literal: true

require "rails_helper"

RSpec.describe CustomCigaretteLog, type: :model do
  describe "アソシエーション" do
    it "user に属する" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "custom_cigarette に属する" do
      association = described_class.reflect_on_association(:custom_cigarette)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "バリデーション" do
    it "全ての属性があれば有効" do
      expect(build(:custom_cigarette_log)).to be_valid
    end

    it "user がなければ無効" do
      log = build(:custom_cigarette_log, user: nil)

      expect(log).not_to be_valid
      expect(log.errors[:user]).to be_present
    end

    it "custom_cigarette がなければ無効" do
      log = build(:custom_cigarette_log, custom_cigarette: nil)

      expect(log).not_to be_valid
      expect(log.errors[:custom_cigarette]).to be_present
    end

    it "packs がなければ無効" do
      log = build(:custom_cigarette_log, packs: nil)

      expect(log).not_to be_valid
      expect(log.errors[:packs]).to be_present
    end

    it "bought_date がなければ無効" do
      log = build(:custom_cigarette_log, bought_date: nil)

      expect(log).not_to be_valid
      expect(log.errors[:bought_date]).to be_present
    end
  end
end
