class MonthlyFeesController < ApplicationController
  before_action :authorize_admin!, only: %i[new index show edit create all]
  before_action :set_student, only: %i[new index create show edit update destroy create_anual_fees]
  before_action :set_monthly_fee, only: %i[show edit update destroy create_all_monthly_fees]

  def new
    @monthly_fee = MonthlyFee.new
  end

  def index
    @monthly_fees = MonthlyFee.includes([:student]).where(student_id: @student.id)
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
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monthly_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  def all
    @monthly_fees = MonthlyFee.includes([:student]).order('due_date')
  end

  def update_paid
    monthly_fee = MonthlyFee.find(params[:items][:id])
    monthly_fee.update(status: params[:items][:status])
    redirect_to request.referer, notice: t('.success')
  end

  def create_anual_fees
    create_all_monthly_fees(@student)
    redirect_to request.referer, notice: t('.success')
  end

  def create_all_anual_fees
    CreateMonthlyFees.perform_async

    redirect_to monthly_fees_path, notice: 'O processo de criação das mensalidades foi iniciado.'
    # students = Student.active
    # students.each do |student|
    #   next if student.current_plan.nil?

    #   create_all_monthly_fees(student)
    # end
    # redirect_to request.referer, notice: t('.success')
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

  def not_paid
    end_of_month = Date.current.end_of_month

    @monthly_fees = MonthlyFee.includes(:student)
                              .where(status: 'Atrasada')
                              .or(
                                MonthlyFee.where(status: 'A pagar', due_date: ..end_of_month)
                              )
                              .order('students.name', 'due_date')
  end

  private

  def create_all_monthly_fees(student)
    current_month = Time.zone.today.month
    current_year = Time.zone.today.year
    start_month = current_month == 1 ? 2 : current_month
    (start_month..12).each do |month|
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
    params.require(:monthly_fee).permit(:due_date, :value, :status)
  end

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end
end
