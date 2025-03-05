class MaterialBilling < ApplicationRecord
  belongs_to :student

  enum status: { pending: 0, paid: 1, canceled: 2 }

  validates :name, :status, :date, :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
end
