class PrivateLessonsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @private_lesson = PrivateLesson.new
  end

  def create
    @private_lesson = PrivateLesson.new(private_lesson_params)
    if @private_lesson.save
      redirect_to @private_lesson, notice: 'Aula particular criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  def edit
  end

  private

  def private_lesson_params
    params.require(:private_lesson).permit(:current_plan_id, :start_time, :end_time, :notes)
  end
end
