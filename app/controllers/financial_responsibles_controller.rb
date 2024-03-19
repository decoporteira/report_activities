class FinancialResponsiblesController < ApplicationController
  before_action :set_responsible, only: %i[show edit update]

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

  def show; end

  def edit
  end

  def update
    if @financial_responsible.update(financial_responsible_params)
      redirect_to @financial_responsible, notice: 'Responsável editado com sucesso.'
    else
      flash[:alert] = 'Não foi possível editar o Responsável.'
      render :edit
    end
  end

  private

  def financial_responsible_params
    params.require(:financial_responsible).permit(:name, :phone, :cpf, :email)
  end

  def set_responsible
    @financial_responsible = FinancialResponsible.find(params[:id])
  end
end