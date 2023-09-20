class Activity < ApplicationRecord
  belongs_to :student
  enum late: { feito: 0, 'entregue com atraso': 1, 'não fez': 2, ausente: 3 }
  validates_presence_of :date, :late, :student_id
end
