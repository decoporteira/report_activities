class StudentsController < ApplicationController
  before_action :cant_see, only: [:report]
  before_action :admin?, except: [:report]
  before_action :set_student, only: %i[show edit update report activities_by_student cant_see]

  def index
    @students = Student.includes([:classroom])
  end

  def show
    return unless current_user.default?

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def new
    @student = Student.new
  end

  def edit
    return unless current_user.default?

    redirect_to root_path
  end

  def create
    if current_user.authorized_user?
      @student = Student.new(student_params)
      save_student
    else
      redirect_to root_path, alert: t('unauthorized_action')
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

  def incomplete
    @students = Student.includes(classroom: :teacher)
                .where(cpf: '', status: :registered)
                .left_outer_joins(:financial_responsibles)
                .where(financial_responsibles: { id: nil })
  end

  def report
    @report_data = @student.generate_report(params[:last_semester])
  end

  private

  def set_student
    @student = report_page? ? Student.find(params[:id]) : Student.includes(responsibles: :financial_responsible).find(params[:id])
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

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def save_student
    respond_to do |format|
      if @student.save
        format.html { redirect_to student_path(@student), notice: t('.success') }
        format.json { render :show, status: :created, location: @student }
      else
        handle_save_failure(format)
      end
    end
  end

  def handle_save_failure(format)
    format.html do
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
    format.json { render json: @student.errors, status: :unprocessable_entity }
  end
end
