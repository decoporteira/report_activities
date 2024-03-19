class FinancialResponsiblesController < ApplicationController

  def index
  end

  def new
    @financial_responsible = FinancialResponsible.new
  end

  def create
    @financial_responsible = FinancialResponsible.new(financial_responsible_params)
    @financial_responsible.save
    redirect_to @financial_responsible, notice: 'Responsável cadastrado com sucesso.'
  end

  def show
  end

  private

  def financial_responsible_params
    params.require(:financial_responsible).permit(:name, :phone, :cpf, :email)
  end
end