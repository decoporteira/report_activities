# frozen_string_literal: true

class ClassroomsController < ApplicationController
  before_action :set_classroom,
                only: %i[show edit update destroy update_current_plan show_details]
  before_action :authorize_admin!, only: %i[index show edit update destroy show_details]
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

  def update_current_plan
    students_into_plan(@classroom, params[:plan_id])
  end

  def show_details; end

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

  def students_into_plan(classroom, plan_id)
    errors = []
    classroom.students.each do |student|
      if student.unregistered?
        errors <<
          "#{student.name}: não está matriculado #{student.errors.full_messages.join(', ')}"
      else
        unless student.update_current_plan(plan_id)
          errors <<
            "#{student.name}: #{student.current_plan.errors.full_messages.join(', ')}"
        end
      end
    end

    respond_to do |format|
      if errors.empty?
        format.html do
          redirect_to classrooms_url,
                      notice: 'Cursos dos alunos alterado com sucesso.'
        end
        format.json { head :no_content }
      else
        format.html do
          redirect_to classrooms_url, alert: "Erros: #{errors.join('; ')}"
        end
        format.json do
          render json: { errors: }, status: :unprocessable_entity
        end
      end
    end
  end
end
