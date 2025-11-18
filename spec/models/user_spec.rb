# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe User, type: :model do
  describe "アソシエーション" do
    it "smokes を多数持つ" do
      association = described_class.reflect_on_association(:smokes)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "smokes を経由して cigarettes を多数持つ" do
      association = described_class.reflect_on_association(:cigarettes)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:smokes)
    end

    it "current_cigarette に任意で属する" do
      association = described_class.reflect_on_association(:current_cigarette)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
      expect(association.options[:class_name]).to eq("Cigarette")
    end

    it "current_custom_cigarette に任意で属する" do
      association = described_class.reflect_on_association(:current_custom_cigarette)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
      expect(association.options[:class_name]).to eq("CustomCigarette")
    end

    it "custom_cigarettes を多数持つ" do
      association = described_class.reflect_on_association(:custom_cigarettes)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "custom_cigarette_logs を多数持つ" do
      association = described_class.reflect_on_association(:custom_cigarette_logs)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "push_subscriptions を多数持つ" do
      association = described_class.reflect_on_association(:push_subscriptions)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "バリデーション" do
    it "name・email・password があれば有効" do
      expect(build(:user)).to be_valid
    end

    it "name がなければ無効" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to be_present
    end

    it "email がなければ無効" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "email が重複すると無効" do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end

    it "password がなければ無効" do
      user = build(:user, password: nil, password_confirmation: nil)

      expect(user).not_to be_valid
      expect(user.errors[:password]).to be_present
    end
  end

  describe "インスタンスメソッド" do
    describe "#total_amount / #total_packs" do
      it "smokes と custom_cigarette_logs を合算する" do
        user = create(:user)
        cigarette = create(:cigarette, price: 500)
        custom_cigarette = create(:custom_cigarette, user:, price: 700)

        create(:smoke, user:, cigarette:, packs: 2)
        create(:custom_cigarette_log, user:, custom_cigarette:, packs: 3)

        expect(user.total_packs).to eq(5)
        expect(user.total_amount).to eq(2 * 500 + 3 * 700)
      end
    end

    describe "#monthly_amounts" do
      it "12ヶ月分を0含めて返す" do
        user = create(:user)
        cigarette = create(:cigarette, price: 500)
        custom_cigarette = create(:custom_cigarette, user:, price: 700)
        year = 2024

        create(:smoke, user:, cigarette:, packs: 1, created_at: Time.zone.local(year, 1, 10))
        create(:custom_cigarette_log, user:, custom_cigarette:, packs: 2, created_at: Time.zone.local(year, 3, 5))

        result = user.monthly_amounts(year: year)

        expect(result.keys.size).to eq(12)
        expect(result["#{year}-01"]).to eq(1 * 500)
        expect(result["#{year}-03"]).to eq(2 * 700)
        expect(result["#{year}-02"]).to eq(0)
      end
    end
  end

  describe ".from_omniauth" do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "12345",
        info: OpenStruct.new(
          email: "user@example.com",
          name: "Example User"
        )
      )
    end

    it "未登録であれば新規作成する" do
      user = described_class.from_omniauth(auth_hash)

      expect(user).to be_persisted
      expect(user.email).to eq("user@example.com")
      expect(user.provider).to eq("google_oauth2")
      expect(user.uid).to eq("12345")
    end

    it "既存メールがあれば更新する" do
      existing = create(:user, email: "user@example.com", name: "Old Name")

      user = described_class.from_omniauth(auth_hash)

      expect(user.id).to eq(existing.id)
      expect(user.name).to eq("Example User")
      expect(user.provider).to eq("google_oauth2")
      expect(user.uid).to eq("12345")
    end
  end
end
