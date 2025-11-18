# frozen_string_literal: true

FactoryBot.define do
  factory :custom_cigarette do
    association :user
    name { "Custom #{Faker::Coffee.blend_name}" }
    price { Faker::Number.between(from: 300, to: 1200) }
  end
end
