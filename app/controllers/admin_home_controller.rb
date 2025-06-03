class AdminHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]

  def index
    @classrooms = Classroom.includes(:students).where(students: { status: 'registered' })
    @students = Student.active.includes(:current_plan)
    @private_students = Student
                              .active
                              .joins(current_plan: :plan)
                              .includes(current_plan: :plan)
                              .where(plans: { billing_type: Plan.billing_types[:per_class] })
    
    plan_counts = @students.joins(current_plan: :plan).group('plans.name').count

    @kids = plan_counts['Kids'] || 0
    @teens = plan_counts['Teens'] || 0
    @adults = plan_counts['Adults'] || 0
    @privates = plan_counts['Particular'] || 0
  end
 
  private

  def check_authorization!
    return if current_user.admin?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
