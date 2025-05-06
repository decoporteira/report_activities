class StudentsController < ApplicationController
  before_action :cant_see, only: [:report]
  before_action :admin?, except: [:report]
  before_action :set_student,
                only: %i[show edit update report activities_by_student cant_see]

  def index
    @students = Student.active.includes([:classroom]).order('students.name')
  end

  def show
    return unless current_user.default?

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def new
    @student = Student.new
  end

  def edit
    @plan_id = @student.current_plan ? @student.current_plan.plan.id : 1

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
        current_plan = @student.current_plan || @student.build_current_plan
        current_plan.update(plan_id: params[:student][:plan_id])
        format.html do
          redirect_to student_path(@student), notice: t('.success')
        end
        format.json { render :info, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @student.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def not_registered
    @students = Student.inactive
  end

  def not_have_current_plan
    @students = Student.inactive
  end

  def activities_by_student
    @activities = @student.activities
  end

  def incomplete
    @students =
      Student
      .includes(classroom: :teacher)
      .where(status: :registered)
      .left_outer_joins(:financial_responsibles)
      .where(financial_responsibles: { id: nil })
      .where(cpf: '')
      .or(
        Student
          .where(status: :registered)
          .where(financial_responsibles: { id: nil })
          .where(email: [nil, ''])
      )
  end

  def report
    @report_data = @student.generate_report(params[:last_semester])
  end

  def email_list
    @active_students = Student.where(status: :registered)
  end

  private

  def set_student
    @student =
      if report_page?
        Student.find(params[:id])
      else
        Student.includes(responsibles: :financial_responsible).find(params[:id])
      end
  end

  def report_page?
    action_name == 'report'
  end

  def student_params
    params
      .require(:student)
      .permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone, :email, :student_plan_id)
  end

  def cant_see
    @student = Student.find(params[:id])
    return if current_user.cpf == @student.cpf || !current_user.default?

    return if current_user_is_financial_responsible?(@student)

    redirect_to root_path, alert: t('.cant_see')
  end

  def current_user_is_financial_responsible?(student)
    student.financial_responsibles.exists?(
      [
        'cpf = :cpf OR email = :email',
        { cpf: current_user.cpf, email: current_user.email }
      ]
    )
  end

  def admin?
    return if current_user.admin? || current_user.accounting? || current_user.teacher?

    redirect_to root_path, alert: t('unauthorized_action')
  end

  def save_student
    respond_to do |format|
      if @student.save
        current_plan = CurrentPlan.find_or_initialize_by(student_id: @student.id)
        current_plan.update(
          plan_id: params[:student][:plan_id]
        )
        format.html do
          redirect_to student_path(@student), notice: t('.success')
        end
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
