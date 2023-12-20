class Address < ApplicationRecord
  #belongs_to :student
  belongs_to :addressable, polymorphic: true
end
