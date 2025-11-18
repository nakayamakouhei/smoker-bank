class CustomCigarette < ApplicationRecord
  belongs_to :user
  has_many :custom_cigarette_logs, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
