class AccountingHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]

  def index
    @classrooms =
      Classroom.includes(:students).where(students: { status: 'registered' })
    @students = Student.registered
    @registered_students = @students.count
    start_of_month = Time.zone.today.beginning_of_month
    end_of_month = Time.zone.today.end_of_month
    start_of_year = Time.zone.today.beginning_of_year
    end_of_year = Time.zone.today.end_of_year

    @total_month = MonthlyFee.where(due_date: start_of_month..end_of_month, status: 'Paga').sum(:value)
    @total_anual = MonthlyFee.where(status: 'Paga', due_date: start_of_year..end_of_year).sum(:value)

    @totals_by_month = 5.downto(0).map do |i|
      month = i.months.ago.beginning_of_month
      label = I18n.l(month, format: "%B")
      total = MonthlyFee.where(due_date: month..month.end_of_month, status: 'Paga').sum(:value)
      [label.capitalize, total]
    end.to_h

    @total_kids = Student.joins(:current_plan)
      .where(current_plans: { plan_id: 1 })
      .where(status: 'registered').count

    @total_teens = Student.joins(:current_plan)
      .where(current_plans: { plan_id: 2 })
      .where(status: 'registered').count

    @total_adults = Student.joins(:current_plan)
      .where(current_plans: { plan_id: 3 })
      .where(status: 'registered').count

    @total_particulares = Student.joins(:current_plan)
      .where(current_plans: { plan_id: 4 })
      .where(status: 'registered').count

    @incomplete_profile = @students =
      Student
      .includes(classroom: :teacher)
      .where(status: :registered)
      .left_outer_joins(:financial_responsibles)
      .where(financial_responsibles: { id: nil })
      .where(cpf: '')
      .or(
        Student
          .where(status: :registered)
          .where(financial_responsibles: { id: nil })
          .where(email: [nil, ''])
      ).count

    @not_paid_percent = MonthlyFee.where(due_date: start_of_month..end_of_month, status: 'A pagar').count * 100 / (MonthlyFee.where(due_date: start_of_month..end_of_month).count.nonzero? || 1)

    @last_montlhy_paids = MonthlyFee.where(status: 'Paga').order(due_date: :desc).limit(6)
    @monthly_fees_late = MonthlyFee.where(status: 'Atrasada').order(due_date: :asc).limit(6)
  end

  private

  def check_authorization!
    return if current_user.accounting?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
