class MonthlyFeesController < ApplicationController
  before_action :authorize_admin!, only: %i[new index show edit create]
  before_action :set_student, only: %i[new index create show edit update create_anual_fees]
  before_action :set_monthly_fee, only: %i[show edit update create_all_monthly_fees]

  def new
    @monthly_fee = MonthlyFee.new
  end

  def index
    @monthly_fees = MonthlyFee.where(student_id: @student.id)
  end

  def show; end

  def edit; end

  def create
    @monthly_fee = @student.monthly_fees.build(monthly_fee_params)
    if @monthly_fee.save
      redirect_to student_path(@student), notice: t('.success')
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @monthly_fee.update(monthly_fee_params)
        format.html { redirect_to student_monthly_fee_path(@monthly_fee.student, @monthly_fee), notice: t('.success')}
        format.json { render :info, status: :ok, location: @monthly_fee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @monthly_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  def all
    @monthly_fees = MonthlyFee.all
  end

  def update_paid
    monthly_fee = MonthlyFee.find(params[:items][:id])
    monthly_fee.update(status: params[:items][:status])
    redirect_to request.referer, notice: 'Mensalidade alterada com sucesso.'
  end

  def create_anual_fees
    create_all_monthly_fees(@student)
    redirect_to request.referer, notice: t('.success')
  end

  private

  def create_all_monthly_fees(student)
    current_month = Date.today.month
    current_year = Date.today.year
    if current_month == 1
      start_month = 2
    else
      start_month == current_month
    end
    (start_month..12).each do |month|
      MonthlyFee.create!(
        student:,
        value: 300,
        due_date: Date.new(current_year, month, 10),
        status: 'A pagar'
      )
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
