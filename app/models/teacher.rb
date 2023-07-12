class Teacher < ApplicationRecord
  has_many :classrooms
  enum status: { 'disponível': 1, 'não disponível': 2 }
end
