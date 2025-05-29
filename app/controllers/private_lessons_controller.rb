class PrivateLessonsController < ApplicationController
  before_action :admin?
  def index; end

  def show; end

  def new
    @private_lesson = PrivateLesson.new

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

  def edit; end

  private

  def admin?
    return if current_user.admin? || current_user.accounting?
    redirect_to root_path, alert: t('unauthorized_action')
  end

  def private_lesson_params
    params.require(:private_lesson).permit(:current_plan_id, :start_time, :notes)
  end
end
