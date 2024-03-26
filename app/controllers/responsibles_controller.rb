class ResponsiblesController < ApplicationController

  def new
    @student = Student.find(params[:student_id])
    @responsible = Responsible.find_by(student_id: params[:student_id])
  end

  def create
    @student = Student.find(params[:student_id])
    @financial_responsible = FinancialResponsible.find(params[:financial_responsible_id])

    responsible = Responsible.new(student_id: @student.id, financial_responsible_id: @financial_responsible.id)
    if responsible.save
      redirect_to @student, notice: 'Responsável vinculado com sucesso.'
    else
      flash[:alert] = 'Não foi possível vincular o Responsável.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def responsible_params
    params.require(:responsible).permit(:student_id, :financial_responsible_id)
  end
end
