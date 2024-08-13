class StudentsController < ApplicationController
  before_action :cant_see, only: [:report]
  before_action :admin?, except: [:report]
  before_action :set_student, only: %i[show edit update report activities_by_student]
  before_action :set_info

  def index
    @students = Student.all
  end

  def show
    return unless current_user.default?

    redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
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
          format.html { redirect_to student_path(@student), notice: 'Student was successfully created.' }
          format.json { render :show, status: :created, location: @student }
        else
          format.html do
            flash.now[:alert] = 'Failed to create student.'
            render :new, status: :unprocessable_entity
          end
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
        format.html { redirect_to student_path(@student), notice: 'Student was successfully updated.' }
        format.json { render :info, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def not_registered
    @students = Student.where(status: 'Não matriculado')
  end

  def activities_by_student
    @activities = @student.activities
  end

  def report
    if params[:year].to_i == 2023
      start_date = Date.new(2023, 8, 1)
      end_date = Date.new(2023, 12, 31).end_of_day
    elsif params[:year].to_i == 2024
      start_date = Date.new(2024, 1, 1)
      end_date = Date.new(2024, 7, 31).end_of_day
    else
      start_date = Date.new(2024, 8, 1)
      end_date = Date.new(2024, 12, 31).end_of_day
    end
    @activities = @student.activities
                          .where('date >= ? AND date <= ?', start_date, end_date)
                          .order(:date)
    set_report(start_date, end_date)
  end

  def incomplete
    @students = Student
                .where(cpf: '', status: 'Matriculado')
                .left_outer_joins(:financial_responsibles)
                .where(financial_responsibles: { id: nil })
  end

  private

  def set_report(start_date, end_date)
    @resume = @student.resumes.where(created_at: start_date..end_date).first
    @dates_with_actitivies = []
    @activities.each do |activity|
      @dates_with_actitivies << activity.date
    end
    @number_of_days = @dates_with_actitivies.uniq.length
    @number_of_absence = @student.attendances
                                  .where(presence: false)
                                  .where('attendance_date >= ? AND attendance_date <= ?', start_date, end_date).length
    @attendance_rate = @number_of_days
    @total_activities = @student.activities.where(date: start_date..end_date)
    @total_activities_done = @total_activities.where(late: 'feito')
    @total_activities_late = @total_activities.where(late: 'entregue com atraso')
    @total_activities_not_done = @total_activities.where(late: 'não fez')
  end

  def set_info
    @activities = Activity.where(student_id: params[:id])
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone, :email)
  end

  def cant_see
    @student = Student.find(params[:id])
    return unless current_user.default?

    return if current_user_is_financial_responsible?(@student)

    redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
  end

  def current_user_is_financial_responsible?(student)
    student.financial_responsibles.exists?(
      ['cpf = :cpf OR email = :email', { cpf: current_user.cpf, email: current_user.email }]
    )
  end

  def admin?
    return if current_user.admin? || current_user.accounting? || current_user.teacher?

    redirect_to root_path,
                alert: 'Você não possui acesso.'
  end
end
