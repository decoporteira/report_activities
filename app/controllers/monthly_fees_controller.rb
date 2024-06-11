class MonthlyFeesController < ApplicationController

  def new
    @student = Student.find(params[:student_id])
    @monthly_fee = MonthlyFee.new
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

  private 

  def monthly_fee_params
    params.require(:monthly_fee).permit(:due_date, :value, :status)
  end
end