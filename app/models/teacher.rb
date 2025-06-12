class Teacher < ApplicationRecord
  belongs_to :user
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :classrooms, dependent: :nullify
  validates :name, presence: true
  enum status: { 'disponível': 1, 'não disponível': 2 }
end
