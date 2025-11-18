# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactForm, type: :model do
  describe "バリデーション" do
    it "name・email・message があれば有効" do
      form = described_class.new(name: "Example", email: "test@example.com", message: "Hello")

      expect(form).to be_valid
    end

    it "message が空でも有効" do
      form = described_class.new(name: "Example", email: "test@example.com", message: "")

      expect(form).to be_valid
    end

    it "name がなければ無効" do
      form = described_class.new(name: nil, email: "test@example.com", message: "Hello")

      expect(form).not_to be_valid
      expect(form.errors[:name]).to be_present
    end

    it "email がなければ無効" do
      form = described_class.new(name: "Example", email: nil, message: "Hello")

      expect(form).not_to be_valid
      expect(form.errors[:email]).to be_present
    end

    it "email の形式が不正だと無効" do
      form = described_class.new(name: "Example", email: "invalid", message: "Hello")

      expect(form).not_to be_valid
      expect(form.errors[:email]).to be_present
    end

    it "message が長すぎると無効" do
      long_message = "a" * 2001
      form = described_class.new(name: "Example", email: "test@example.com", message: long_message)

      expect(form).not_to be_valid
      expect(form.errors[:message]).to be_present
    end
  end
end
