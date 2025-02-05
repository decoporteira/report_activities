class CurrentPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :student
  before_save :set_total
  validate :single_current_plan_per_student

  def discounted_price
    if has_discount
      plan.price * (1 - discount.to_f / 100)
    else
      plan.price
    end
  end

  private

  def set_total
    self.total = define_total
  end

  def define_total
    if has_discount
      plan.price * (1 - (discount / 100.0))
    else
      plan.price
    end
  end

  def single_current_plan_per_student
    return unless new_record? && CurrentPlan.exists?(student_id:)

    errors.add(:student_id, 'already has a current plan.')
  end

end
