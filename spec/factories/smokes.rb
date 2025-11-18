# frozen_string_literal: true

FactoryBot.define do
  factory :smoke do
    association :user
    association :cigarette
    packs { Faker::Number.between(from: 1, to: 10) }
    bought_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
  end
end
