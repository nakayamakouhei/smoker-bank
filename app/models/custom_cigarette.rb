class CustomCigarette < ApplicationRecord
  belongs_to :user
  has_many :custom_cigarette_logs, dependent: :destroy
end
