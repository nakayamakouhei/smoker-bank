class CustomCigaretteLog < ApplicationRecord
  belongs_to :user
  belongs_to :custom_cigarette

  validates :packs, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :bought_date, presence: true
end
