class Activity < ApplicationRecord
  belongs_to :student
  enum late: { feito: 0, 'entregue com atraso': 1, 'não fez': 2 }
  validates :date, :late, :student_id, presence: true

  scope :set_done_activities, -> { where(late: 'feito') }
  scope :set_late_activities, -> { where(late: 'entregue com atraso') }
  scope :set_not_done_activities, -> { where(late: 'não fez') }
end
