class AdminHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]

  def index
    @classrooms =
      Classroom.includes(:students).where(students: { status: 'registered' })

    @students = Student.registered
    @current_plans = CurrentPlan.joins(:student).merge(Student.active).order('students.name')

    @current_plan_kids = fetch_students_by_plan_name('Kids')
    @current_plan_adults = fetch_students_by_plan_name('Adults')
    @current_plan_privates = fetch_students_by_plan_name('Particular')
  end

  private

  def fetch_students_by_plan_name(plan_name)
    Student.joins(:current_plan)
           .where(current_plans: { plan_id: Plan.where(name: plan_name).pluck(:id) })
  end

  def check_authorization!
    return if current_user.admin?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
