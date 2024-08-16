class StudentsController < ApplicationController
  before_action :cant_see, only: [:report]
  before_action :admin?, except: [:report]
  before_action :set_student, only: %i[show edit update report activities_by_student cant_see]
  before_action :set_info

  def index
    @students = Student.includes([:classroom])
  end

  def show
    return unless current_user.default?

    redirect_to root_path, alert: 'Você naaão possui acesso a esse aluno.'
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
          format.html { redirect_to student_path(@student), notice: t('.success') }
          format.json { render :show, status: :created, location: @student }
        else
          format.html do
            flash.now[:alert] = t('.fail')
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
    @students = Student.includes([:classroom]).where(status: :not_registered)
  end

  def activities_by_student
    @activities = @student.activities
  end

  def report
    @student = Student.find(params[:id])
    start_date, end_date = determine_date_range(params[:year].to_i)
    @activities = @student.find_activities(start_date, end_date)
    @resume = @student.set_resume(start_date, end_date)
    @total_activities_done = @student.set_done_activities
    @total_activities_late = @student.set_late_activities
    @total_activities_not_done = @student.set_not_done_activities
    @dates_with_activities = @student.activities.where(date: start_date..end_date).pluck(:date).uniq

    @attendance_rate = 10
    @number_of_absence = 1
  end

  def incomplete
    @students = Student.includes(classroom: :teacher)
                .where(cpf: '', status: :registered)
                .left_outer_joins(:financial_responsibles)
                .where(financial_responsibles: { id: nil })
  end

  private

  def determine_date_range(year)
    case year
    when 2023
      start_date = Date.new(2023, 8, 1)
      end_date = Date.new(2023, 12, 31).end_of_day
    when 2024
      start_date = Date.new(2024, 1, 1)
      end_date = Date.new(2024, 7, 31).end_of_day
    else
      start_date = Date.new(2024, 8, 1)
      end_date = Date.new(2024, 12, 31).end_of_day
    end
    [start_date, end_date]
  end
  # def set_report(start_date, end_date)
   

  #   @dates_with_activities = @student.activities.where(date: start_date..end_date).pluck(:date).uniq
  #   @number_of_days = @dates_with_activities.size

  #   @number_of_absence =  @student.attendances
  #                                 .where(presence: false)
  #                                 .where(attendance_date: start_date..end_date).count

  #   @total_activities = @student.activities.where(date: start_date..end_date)
    

  #   @attendance_rate = @number_of_days
  # end

  def set_info
    @activities = Activity.where(student_id: params[:id])
  end

  def set_student
    @student =  if report_page?
                  Student.find(params[:id])
                else
                  Student.includes(responsibles: :financial_responsible).find(params[:id])
                end
  end

  def report_page?
    action_name == 'report'
  end

  def student_params
    params.require(:student).permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone, :email)
  end

  def cant_see
    @student = Student.find(params[:id])
    return if current_user.cpf == @student.cpf || !current_user.default?

    return if current_user_is_financial_responsible?(@student)

    redirect_to root_path, alert: t('.cant_see')
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
