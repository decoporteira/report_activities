class MonthlyFeesController < ApplicationController
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

  def create
    @student = Student.find(params[:student_id])
    @monthly_fee = @student.monthly_fees.build(monthly_fee_params)
    if @monthly_fee.save
      redirect_to student_path(@student), notice: t('.success')
    else
      render :new
    end
  end

  def all
    @monthly_fees = MonthlyFee.all
  end

  private

  def monthly_fee_params
    params.require(:monthly_fee).permit(:due_date, :value, :status)
  end
end
