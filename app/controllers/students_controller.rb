class StudentsController < ApplicationController
  before_action :cant_see, only: [:show]
  before_action :is_admin?, except: [:show]
  before_action :set_student, only: %i[show edit update destroy info show_2023 activities_by_student]
  before_action :get_info

  def create_student(name, classroom_id)
    Student.find_or_create_by!(name:, status: 1, classroom_id:)
  end

  def create_activity(student_id, report, date)
    date += '/2023'
    Activity.create!(student_id:, report:, date:, late: 0)
  end

  def index
    @students = Student.all
  end

  def show
    if current_user.default? && @student.cpf != current_user.cpf
      return redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
    end

    if params[:year].to_i == 2023
      @activities = @student.activities.where('date <= ?', Date.new(2023, 12, 31)).order(:date)
      @resume = @student.resumes.first
    else
      @activities = @student.activities.where('date >= ?', Date.new(2024, 1, 1)).order(:date)
      @resume
    end

    @dates_with_actitivies = []
    @activities.each do |activity|
      @dates_with_actitivies << activity.date
    end
    @number_of_days = @dates_with_actitivies.uniq.length
    @number_of_absence = @student.attendances.where(presence: false).where('attendance_date >= ?',
                                                                           Date.new(2024, 1, 1)).length
    @attendance_rate = @number_of_days
  end

  def show_2023
    if current_user.default? && @student.cpf != current_user.cpf
      return redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
    end

    @activities = @student.activities.sort_by(&:date)
    @dates_with_actitivies = []
    @activities.each do |activity|
      @dates_with_actitivies << activity.date
    end
    @number_of_days = @dates_with_actitivies.uniq.length

    @number_of_absence = @student.attendances.where(presence: false).length
    @attendance_rate = @number_of_days
  end

  def new
    @student = Student.new
  end

  def edit
    return unless current_user.default?

    redirect_to root_path
  end

  def create
    if current_user.admin? || current_user.accounting?
      @student = Student.new(student_params)
      respond_to do |format|
        if @student.save
          format.html { redirect_to info_student_path(@student), notice: 'Student was successfully created.' }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Você não tem permissão para cadastrar novos alunos.'
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to info_student_path(@student), notice: 'Student was successfully updated.' }
        format.json { render :info, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.admin?
      @student.destroy
      respond_to do |format|
        format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: 'Você não tem permissão.'
    end
  end

  def info
    return unless current_user.default?

    redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
  end

  def not_registered
    @students = Student.where(status: 'Não matriculado')
  end

  def activities_by_student
    @activities = @student.activities
  end

  private

  def get_info
    @activities = Activity.where(student_id: params[:id])
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone)
  end

  def cant_see
    @student = Student.find(params[:id])
    return unless current_user.default?
    return if current_user.cpf == @student.cpf && @student.cpf != '' && !@student.cpf.nil?

    redirect_to root_path, alert: 'Você não possui acesso.'
  end

  def is_admin?
    return if current_user.admin? || current_user.accounting? || current_user.teacher?

    redirect_to root_path,
                alert: 'Você não possui acesso.'
  end
end
