class Teacher < ApplicationRecord
  belongs_to :user
  has_many :addresses, as: :addressable
  has_many :classrooms, dependent: :destroy
  validates_presence_of :name
  enum status: { 'disponível': 1, 'não disponível': 2 }
end
