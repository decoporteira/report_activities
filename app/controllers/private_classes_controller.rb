class PrivateClassesController < ApplicationController
before_action :admin?
  def index
    @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today
    start_of_month = @date.beginning_of_month
    end_of_month = @date.end_of_month

    @private_lessons = PrivateLesson
                       .includes(current_plan: [:student, :teacher])
                       .where(start_time: start_of_month..end_of_month)

    @teachers = Teacher.all
    @lesson_counts = @private_lessons
                     .joins(:current_plan)
                     .group('current_plans.teacher_id')
                     .count

    @lesson_values = @private_lessons
                     .joins(:current_plan)
                     .group('current_plans.teacher_id')
                     .sum('current_plans.value_per_hour')
    @teachers = Teacher.where(id: @lesson_counts.keys).index_by(&:id)
  end

  private
  def admin?
    return if current_user.admin? || current_user.accounting?

    redirect_to root_path, alert: t('unauthorized_action')
  end
end