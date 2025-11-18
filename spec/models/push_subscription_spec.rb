# frozen_string_literal: true

require "rails_helper"

RSpec.describe PushSubscription, type: :model do
  describe "アソシエーション" do
    it "user に属する" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "バリデーション" do
    it "全ての属性があれば有効" do
      expect(build(:push_subscription)).to be_valid
    end

    it "user がなければ無効" do
      push_subscription = build(:push_subscription, user: nil)

      expect(push_subscription).not_to be_valid
      expect(push_subscription.errors[:user]).to be_present
    end
  end
end
