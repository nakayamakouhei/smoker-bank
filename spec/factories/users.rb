# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| Faker::Internet.unique.email(name: "user#{n}") }
    password { "Password123!" }
    password_confirmation { password }
    provider { nil }
    uid { nil }
  end
end
