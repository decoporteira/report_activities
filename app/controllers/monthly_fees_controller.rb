class MonthlyFeesController < ApplicationController
  before_action :authorize_admin!, only: %i[new index show edit create all fee_list]
  before_action :set_student, only: %i[new create show edit update destroy create_anual_fees_for_student]
  before_action :set_monthly_fee, only: %i[show edit update destroy create_all_monthly_fees]

  def new
    @monthly_fee = MonthlyFee.new
  end

  def index
    @students =
      if params[:year] == '2025'
        Student.with_monthly_fees_for_year(params[:year]).order(:name)
      else
        Student.with_monthly_fees_for_semester('2025').order(:name)
      end
  end

  def show; end

  def edit; end

  def create
    @monthly_fee = @student.monthly_fees.build(monthly_fee_params)
    if @monthly_fee.save
      redirect_to student_path(@student), notice: t('.success')
    else
      render :edit
    end
  end

  def update
    respond_to do |format|
      if @monthly_fee.update(monthly_fee_params)
        format.html { redirect_to student_monthly_fee_path(@monthly_fee.student, @monthly_fee), notice: t('.success') }
        format.json { render :info, status: :ok, location: @monthly_fee }
        update_current_plan
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monthly_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  def all
    @monthly_fees = MonthlyFee.includes([:student]).order('students.name')
  end

  def update_paid
    mf = MonthlyFee.find(params[:items][:id])
    status = params[:items][:status]
    if status == 'Paga'
      value = params[:valor_pagamento].presence || mf.calculate_payment_value
      attrs = { status:, payment_date: Time.zone.today - 1.day }
      attrs[:value] = value if value.present?
      mf.update(attrs)
    else
      mf.update(status:)
    end
    redirect_to request.referer, notice: t('.success')
  end

  def create_anual_fees_for_student
    create_all_monthly_fees(@student)
    redirect_to request.referer, notice: t('.success')
  end

  def create_all_anual_fees
    CreateAnualFees.perform_async
    redirect_to monthly_fees_path, notice: 'O processo de criação das
                                      mensalidades foi iniciado com sucesso.'
  end

  def destroy
    if @monthly_fee.destroy
      respond_to do |format|
        format.html { redirect_to student_path(@student), notice: t('.success') }
        format.json { head :no_content }
      end
    else
      redirect_to @classroom, alert: t('.fail')
    end
  end

  def monthly_fees_by_student
    @student = Student.find(params[:id])
    @monthly_fees = @student.monthly_fees.order(:due_date)
    @current_plan = @student.current_plan
    @financial_responsibles = @student.financial_responsibles
  end

  def new_index
    @students =
      if params[:type] == 'classroom'
        Student.classroom_with_monthly_fees_for_year('2025').order(:name)
      elsif params[:type] == 'private'
        Student.private_with_monthly_fees_for_year('2025').order(:name)
      else
        Student.both_with_monthly_fees_for_year('2025').order(:name)
      end
  end

  def show_late_fees
    month = if params[:month] == 'one_month_ago'
              Time.zone.today.month - 1
            elsif params[:month] == 'two_months_ago'
              Time.zone.today.month - 2
            else
              Time.zone.today.month
            end
    base_date =
      case params[:month]
      when 'one_month_ago'
        Time.zone.today.prev_month
      when 'two_months_ago'
        2.months.ago.to_date
      else
        Time.zone.today
      end

    if base_date.month == Time.zone.today.month && Time.zone.today.day <= 10
      @email_map = {}
      return
    end

    @students = Student.joins(:monthly_fees, current_plan: :plan)
                       .where(plans: { billing_type: :monthly })
                       .where(monthly_fees: { status: 'Atrasada',
                                              due_date: Date.new(Time.zone.today.year, month, 10)})
                       .active

    @email_map = {}

    @students.each do |student|
      if student.financial_responsibles.any?
        responsible = student.financial_responsibles.first
        responsible_name = responsible.name
        email = responsible.email
        responsible_id = responsible.id
      else
        email = student.email
      end

      name = student.name

      if @email_map[email]
        @email_map[email][:students] << {
          id: student.id,
          name:,
          responsible: responsible_name.presence || 'Sem responsável',
          responsible_id: responsible_id.presence || 'Sem responsável'
        }
      else
        @email_map[email] = {
          email:,
          students: [
            {
              id: student.id,
              name:,
              responsible: responsible_name.presence || 'Sem responsável',
              responsible_id: responsible_id.presence || 'Sem responsável'
            }
          ]
        }
      end
    end
  end

  private

  def update_current_plan
    current_plan = @monthly_fee.student.current_plan
    has_discount = !(current_plan.plan.price - @monthly_fee.value).zero?
    current_plan.update(has_discount:, discount: current_plan.plan.price - @monthly_fee.value)
  end

  def create_all_monthly_fees(student)
    current_month = Time.zone.today.month
    current_year = Time.zone.today.year
    start_month = current_month == 1 ? 2 : current_month
    (start_month..12).each do |month|
      next if student.monthly_fees.exists?(due_date: Date.new(current_year, month, 10))

      MonthlyFee.create!(student:, value: student.current_plan.discounted_price,
                         due_date: Date.new(current_year, month, 10), status: 'A pagar')
    end
  end

  def set_monthly_fee
    @monthly_fee = MonthlyFee.find(params[:id])
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def monthly_fee_params
    params.require(:monthly_fee).permit(:due_date, :value, :status, :payment_date)
  end

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end
end
