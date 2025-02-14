class Plan < ApplicationRecord
  validates :name, :price, presence: true
  has_many :current_plans
end
