class CurrentPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :student
  before_save :set_total
  validate :single_current_plan_per_student
  validate :positive_price

  def discounted_price
    if has_discount
      (plan.price - discount.to_f)
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
      (plan.price - discount.to_f)
    else
      plan.price
    end
  end

  def single_current_plan_per_student
    return unless new_record? && CurrentPlan.exists?(student_id:)

    errors.add(:student_id, 'already has a current plan.')
  end

  def positive_price
    return unless discount.present? && plan&.price.present?
    return unless discount > plan.price

    errors.add(:student_id, 'Valor da mensalidade não pode ser negativa.')
  end
end
