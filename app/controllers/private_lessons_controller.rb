class PrivateLessonsController < ApplicationController
  before_action :admin?
  def index
    @private_lessons = PrivateLesson.joins(:current_plan).where(current_plans: {teacher_id: current_user.teacher.id})
  end

  def show
    @private_lesson = PrivateLesson.find(params[:id])
    @current_plan = @private_lesson.current_plan
    @student = @current_plan.student
    @teacher = @current_plan.teacher
  end

  def new
    @private_lesson = PrivateLesson.new
      @current_plans = if current_user.teacher?
                          CurrentPlan.joins(:plan, :student).where(
                          plans: { billing_type: :per_class },
                          current_plans: { teacher_id: current_user.teacher.id }
                        )
                      else
                          CurrentPlan.joins(:plan).where(plans: { billing_type: :per_class })
                      end

    if params[:start_date].present?
      date = Date.parse(params[:start_date]) rescue nil
      @private_lesson.start_time = date&.to_time&.change(hour: 8)
    end
  end

  def create
    @private_lesson = PrivateLesson.new(private_lesson_params)

    @private_lesson.end_time = @private_lesson.start_time + 1.hour
    if @private_lesson.save
      redirect_to @private_lesson, notice: 'Aula particular criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @private_lesson = PrivateLesson.find(params[:id])
    @current_plans = if current_user.teacher?
      CurrentPlan.joins(:plan, :student).where(
      plans: { billing_type: :per_class },
      current_plans: { teacher_id: current_user.teacher.id }
    )
    else
      CurrentPlan.joins(:plan).where(plans: { billing_type: :per_class })
    end

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

  private

  def admin?
    return unless current_user.default?

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def private_lesson_params
    params.require(:private_lesson).permit(:current_plan_id, :start_time, :notes)
  end
end
