class FinancialResponsiblesController < ApplicationController

  def index
    @financial_responsibles = FinancialResponsible.all
  end

  def new
    @financial_responsible = FinancialResponsible.new
  end

  def create
    @financial_responsible = FinancialResponsible.new(financial_responsible_params)
    if @financial_responsible.save
      redirect_to @financial_responsible, notice: 'Responsável cadastrado com sucesso.'
    else
      flash[:alert] = 'Não foi possível cadastrar o Responsável.'
      render :new
    end
  end

  def show
  end

  private

  def financial_responsible_params
    params.require(:financial_responsible).permit(:name, :phone, :cpf, :email)
  end
end