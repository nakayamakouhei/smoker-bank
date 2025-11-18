# frozen_string_literal: true

FactoryBot.define do
  factory :push_subscription do
    association :user
    endpoint { Faker::Internet.url }
    p256dh { Faker::Alphanumeric.alphanumeric(number: 86) }
    auth { Faker::Alphanumeric.alphanumeric(number: 24) }
  end
end
