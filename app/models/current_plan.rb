class CurrentPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :student

  validate :single_current_plan_per_student

  private

  def single_current_plan_per_student
    if new_record? && CurrentPlan.exists?(student_id: student_id)
      errors.add(:student_id, 'already has a current plan.')
    end
  end
end
