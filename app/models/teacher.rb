class Teacher < ApplicationRecord
  has_many :classrooms, dependent: :destroy
  enum status: { 'disponível': 1, 'não disponível': 2 }
end
