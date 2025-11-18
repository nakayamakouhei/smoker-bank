# frozen_string_literal: true

FactoryBot.define do
  factory :custom_cigarette_log do
    association :custom_cigarette
    user { custom_cigarette&.user || association(:user) }
    packs { Faker::Number.between(from: 1, to: 10) }
    bought_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
  end
end
