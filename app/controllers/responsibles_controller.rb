class ResponsiblesController < ApplicationController
  before_action :set_student, only: %i[new create]

  def new
    @responsible = Responsible.find_by(student_id: params[:student_id])
  end

  def create
    @financial_responsible =
      FinancialResponsible.find(params[:financial_responsible_id])

    responsible =
      Responsible.new(
        student_id: @student.id,
        financial_responsible_id: @financial_responsible.id
      )
    if responsible.save
      redirect_to @student, notice: 'Responsável vinculado com sucesso.'
    else
      flash[:alert] = 'Não foi possível vincular o Responsável.'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @responsible = Responsible.find(params[:id])
  end

  def destroy
    @responsible = Responsible.find(params[:id])
    @responsible.destroy
    redirect_to financial_responsible_path(
      @responsible.financial_responsible.id
    ),
                notice: 'Responsável removido com sucesso.'
  end

  private

  def responsible_params
    params.require(:responsible).permit(:student_id, :financial_responsible_id)
  end

  def set_student
    @student = Student.find(params[:student_id])
  end
end
