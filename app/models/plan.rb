class Plan < ApplicationRecord
  validates :name, :price, presence: true
  has_many :current_plans
  has_many :students, through: :current_plans
  
  enum billing_type: { monthly: 0, per_class: 1, both: 2 }
end
