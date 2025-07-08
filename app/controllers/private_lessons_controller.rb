class PrivateLessonsController < ApplicationController
  before_action :admin?
  def index
    @private_lessons = if current_user.admin?
                        @teacher = Teacher.first
                         PrivateLesson.joins(:current_plan).where(current_plans: {teacher_id: 1})
                       else
                        @teacher = Teacher.find(current_user.teacher.id)
                         PrivateLesson.joins(:current_plan).where(current_plans: {teacher_id: current_user.teacher.id})
                       end
    @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Time.zone.today
    start_of_month = @date.beginning_of_month
    end_of_month = @date.end_of_month
    @month_classes = @private_lessons.where(start_time: start_of_month..end_of_month.end_of_day)
    @month_total = @month_classes.sum('current_plans.value_per_hour') / 2

    @private_lessons = PrivateLesson
                       .includes(current_plan: %i[student teacher])
                       .joins(current_plan: :teacher)
                       .where(start_time: start_of_month..end_of_month.end_of_day)
                       .where(current_plans: { teacher_id: @teacher.id })

    @lesson_counts = @private_lessons
                     .joins(:current_plan)
                     .group('current_plans.student_id')
                     .count

    @lesson_values = @private_lessons
                     .joins(:current_plan)
                     .group('current_plans.student_id')
                     .sum('current_plans.value_per_hour')

   @lesson_values_per_teacher = @private_lessons
                     .joins(:current_plan)
                     .group('current_plans.teacher_id')
                     .sum('current_plans.value_per_hour')

  end

  def show
    @private_lesson = PrivateLesson.find(params[:id])
    @current_plan = @private_lesson.current_plan
    @student = @current_plan.student
    @teacher = @current_plan.teacher
  end

  def new
    @private_lesson = PrivateLesson.new
    @current_plans = define_current_plans

    if params[:start_date].present?
      date = Date.parse(params[:start_date]) rescue nil
      @private_lesson.start_time = date&.to_time&.change(hour: 8)
    end
  end

  def create
    @private_lesson = PrivateLesson.new(private_lesson_params)
    #student = @private_lesson.current_plan.student
    #monthly_fee = student.monthly_fees.find_by(due_date: @private_lesson.start_time.beginning_of_month..@private_lesson.start_time.end_of_month)
    #monthly_fee.update(status: 'Paga') if monthly_fee.present?
    @private_lesson.end_time = @private_lesson.start_time + 1.hour
    if @private_lesson.save

      redirect_to @private_lesson, notice: 'Aula particular criada com sucesso.'
    else
      @current_plans = define_current_plans
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @private_lesson = PrivateLesson.find(params[:id])
    @current_plans = define_current_plans
  end

  def update
    @private_lesson = PrivateLesson.find(params[:id])
    @private_lesson.end_time = @private_lesson.start_time + 1.hour

    if @private_lesson.update(private_lesson_params)
      redirect_to @private_lesson, notice: 'Aula particular atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @private_lesson = PrivateLesson.find(params[:id])
    @private_lesson.destroy
    redirect_to private_lessons_path, notice: 'Aula particular excluída com sucesso.'
  end

  def new_lesson_admin
    @private_lesson = PrivateLesson.new
    @current_plans = CurrentPlan.joins(:plan, :student).where(plans: { billing_type: [Plan.billing_types[:per_class], Plan.billing_types[:both]] }).order('student.name')

    if params[:start_date].present?
      date = Date.parse(params[:start_date]) rescue nil
      @private_lesson.start_time = date&.to_time&.change(hour: 8)
    end
    
  end
  private

  def admin?
    return unless current_user.default?

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def private_lesson_params
    params.require(:private_lesson).permit(:current_plan_id, :start_time, :notes)
  end

  def define_current_plans
    scope = CurrentPlan.joins(:plan, :student)
                      .where(plans: { billing_type: [Plan.billing_types[:per_class], Plan.billing_types[:both]] })

    teacher_id =
      if current_user.teacher?
        current_user.teacher.id
      elsif current_user.admin?
        1
      end

    scope = scope.where(current_plans: { teacher_id: }) if teacher_id.present?
    scope.order('students.name')
  end
end
