# frozen_string_literal: true

FactoryBot.define do
  factory :cigarette do
    sequence(:name) { |n| "Cigarette #{n}" }
    price { Faker::Number.between(from: 300, to: 900) }
    manufacturer { Faker::Company.name }
    sequence(:position, 1) { |n| n }
  end
end
