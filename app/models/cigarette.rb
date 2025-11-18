class Cigarette < ApplicationRecord
  has_many :smokes, dependent: :destroy
  has_many :users, through: :smokes

  validates :name, presence: true, uniqueness: true
  validates :manufacturer, presence: true
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, uniqueness: { scope: :manufacturer }
end
