class AdminHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]

  def index
    @classrooms = Classroom.includes(:students).where(students: { status: 'registered' })
    @students = Student.active.includes(:current_plan)

    plan_counts = @students.joins(:current_plan).group('current_plans.plan_id').count

    @kids = plan_counts[1] || 0
    @teens = plan_counts[2] || 0
    @adults = plan_counts[3] || 0
    @privates = plan_counts[4] || 0
  end

  private

  def check_authorization!
    return if current_user.admin?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
