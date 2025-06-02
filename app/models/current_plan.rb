class CurrentPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :student
  before_save :set_total
  belongs_to :teacher, optional: true

  validates :student_id, uniqueness: { message: 'já possui um plano ativo' }

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

  def positive_price
    return unless discount.present? && plan&.price.present?

    if discount > plan.price
      errors.add(:discount, 'O desconto não pode ser maior que o valor do plano.')
    elsif discount.negative?
      errors.add(:discount, 'O desconto não pode ser negativo.')
    end
  end
end
