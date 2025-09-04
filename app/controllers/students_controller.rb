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
        current_plan.update(plan_id: params[:student][:plan_id]) if params[:student][:plan_id].present?
        current_plan.update(value_per_hour: params[:student][:value_per_hour]) if params[:student][:value_per_hour].present?
        current_plan.update(teacher_id: params[:student][:teacher_id]) if params[:student][:teacher_id].present?
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

  def private_classes_students
    @students = Student.with_plan_per_class
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
    @active_students = Student.joins(:monthly_fees).where(monthly_fees: { due_date: Time.zone.today.change(day: 10), status: 1 }).active
    @email_map = {}

    @active_students.each do |student|
      if student.responsibles.any?
        student.responsibles.each do |fr|
          email = fr.financial_responsible.email
          name  = fr.financial_responsible.name
          @email_map[email] ||= name
        end
      else
        email = student.email
        name  = student.name
        @email_map[email] ||= name
      end
    end
  end

  def private_classes_value
    student = Student.find(params[:id])
    date = Date.parse(params[:date])
    value = student.get_private_classes(date)

    render json: { value: view_context.number_to_currency(value, unit: "") }
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
      .permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone, :email)
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
        create_monthly_fee(@student)
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
  
  def create_monthly_fee(student)
    current_month = Time.zone.today.month
    current_year = Time.zone.today.year
    current_month = current_month == 1 ? 2 : current_month
    unless student.monthly_fees.exists?(due_date: Date.new(current_year, current_month, 10))
      MonthlyFee.create!(
        student: student,
        value: student.current_plan.discounted_price,
        due_date: Date.new(current_year, current_month, 10),
        status: 'A pagar'
      )
    end
  end
end