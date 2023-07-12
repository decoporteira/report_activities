class Student < ApplicationRecord
  belongs_to :classroom
  enum status: { 'Matriculado': 1, 'Não matriculado': 2 }
end
