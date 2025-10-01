class Cigarette < ApplicationRecord
  has_many :smokes, dependent: :destroy
  has_many :users, through: :smokes
end
