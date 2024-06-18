class MonthlyFeesController < ApplicationController
  before_action :authorize_admin!, only: %i[new index show edit update]

  def new
    @student = Student.find(params[:student_id])
    @monthly_fee = MonthlyFee.new
  end

  def index
    @student = Student.find(params[:student_id])
    @monthly_fees = MonthlyFee.where(student_id: @student.id)
  end

  def show
    @student = Student.find(params[:student_id])
    @monthly_fee = MonthlyFee.find(params[:id])
  end

  def edit
    @student = Student.find(params[:student_id])
    @monthly_fee = MonthlyFee.find(params[:id])
  end

  def create
    @student = Student.find(params[:student_id])
    @monthly_fee = @student.monthly_fees.build(monthly_fee_params)
    if @monthly_fee.save
      redirect_to student_path(@student), notice: t('.success')
    else
      render :new
    end
  end

  def update
    @monthly_fee = MonthlyFee.find(params[:id])
    @student = Student.find(params[:student_id])
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
    Rails.logger.info("-------------------------------------------> " + request.path)
    monthly_fee = MonthlyFee.find(params[:id])
    monthly_fee.update(status: 'Pago')
    redirect_to request.referer, notice: 'Mensalidade foi paga com sucesso.'
  end

  def update_pending
    monthly_fee = MonthlyFee.find(params[:id])
    monthly_fee.update(status: 'A pagar')
    redirect_to request.referer, notice: 'Mensalidade marcada como pendente.'
  end

  def update_late
    monthly_fee = MonthlyFee.find(params[:id])
    monthly_fee.update(status: 'Pagamento em atraso')
    redirect_to request.referer, notice: 'Mensalidade marcada como atrasada.'
  end

  private

  def monthly_fee_params
    params.require(:monthly_fee).permit(:due_date, :value, :status)
  end

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end
end
