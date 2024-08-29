class Plan < ApplicationRecord
  validates :name, :price, presence: true
end
