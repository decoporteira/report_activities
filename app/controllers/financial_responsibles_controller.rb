class FinancialResponsiblesController < ApplicationController
  before_action :set_responsible, only: %i[show edit update]
  before_action :authorize_admin!

  def index
    @financial_responsibles = FinancialResponsible.all
  end

  def new
    debugger
    @financial_responsible = FinancialResponsible.new
    @student = Student.find(params[:student_id])
  end

  def create
    
    @financial_responsible = FinancialResponsible.new(financial_responsible_params)
    if @financial_responsible.save
      responsible = Responsible.new(student_id: params[:student_id], financial_responsible_id: @financial_responsible.id)
      if responsible.save
        redirect_to @financial_responsible, notice: t('.success')
      else
        flash.now[:alert] = t('.fail')
        return render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = t('.fail')
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit
  end

  def update
    if @financial_responsible.update(financial_responsible_params)
      redirect_to @financial_responsible, notice: 'Responsável editado com sucesso.'
    else
      flash[:alert] = 'Não foi possível editar o Responsável.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end

  def financial_responsible_params
    params.require(:financial_responsible).permit(:name, :phone, :cpf, :email)
  end

  def set_responsible
    @financial_responsible = FinancialResponsible.find(params[:id])
  end
end
