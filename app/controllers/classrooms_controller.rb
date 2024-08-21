# frozen_string_literal: true

class ClassroomsController < ApplicationController
  before_action :set_classroom, only: %i[show edit update destroy]
  before_action :authorize_admin!, only: %i[index show edit update destroy]
  before_action :authorize_creation, only: %i[new]
  before_action :set_students, only: %i[show]

  def index
    @classrooms = Classroom.includes([:teacher])
  end

  def show
    @classroom_data = @classroom.generate_data(params[:last_semester])
  end

  def new
    @classroom = Classroom.new
  end

  def edit; end

  def create_activity
    students =
      Student.where(classroom_id: params[:classroom_id], status: :registered)
    students.each { |student| create_activity_and_attendance(student) }
    redirect_to request.referer, notice: t('.success')
  end

  def create
    @classroom = Classroom.new(classroom_params)

    respond_to do |format|
      if @classroom.save
        format.html do
          redirect_to classroom_url(@classroom), notice: t('.success')
        end
        format.json { render :show, status: :created, location: @classroom }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @classroom.update(classroom_params)
        format.html do
          redirect_to classroom_url(@classroom), notice: t('.success')
        end
        format.json { render :show, status: :ok, location: @classroom }
      else
        format.html do
          render :edit, status: :unprocessable_entity, notice: t('.fail')
        end
        format.json do
          render json: @classroom.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    if current_user.admin? && @classroom.students.count.zero?
      @classroom.destroy
      respond_to do |format|
        format.html { redirect_to classrooms_url, notice: t('.success') }
        format.json { head :no_content }
      end
    else
      redirect_to @classroom, alert: t('.fail')
    end
  end

  private

  def authorize_admin!
    return if current_user.admin? || current_user.teacher?

    redirect_to root_path, alert: t('.denied')
  end

  def authorize_creation
    redirect_to root_path, alert: t('.denied') unless current_user.admin?
  end

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params.require(:classroom).permit(:name, :time, :teacher_id)
  end

  def set_students
    @students = Student.where(classroom_id: params[:id], status: :registered)
  end

  def create_activity_and_attendance(student)
    Activity.create!(
      student_id: student.id,
      report: params[:report],
      date: params[:date],
      late: params[:late]
    )
    Attendance.find_or_create_by!(
      student_id: student.id,
      attendance_date: params[:date],
      presence: true
    )
  end
end
