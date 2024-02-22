class Activity < ApplicationRecord
  belongs_to :student
  enum late: { feito: 0, 'entregue com atraso': 1, 'não fez': 2 }
  validates :date, :late, :student_id, presence: true
end
