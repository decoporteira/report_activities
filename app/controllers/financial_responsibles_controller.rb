class FinancialResponsiblesController < ApplicationController
  before_action :set_responsible, only: %i[show edit update]
  before_action :set_student, only: %i[new]
  before_action :authorize_admin!

  def index
    @financial_responsibles = FinancialResponsible.all
  end

  def new
    @financial_responsible = FinancialResponsible.new
  end

  def create
    @student = Student.find(financial_responsible_params[:student_id]) 
    @financial_responsible = FinancialResponsible.new(name: financial_responsible_params[:name],
                                                      phone: financial_responsible_params[:phone],
                                                      cpf: financial_responsible_params[:phone],
                                                      email: financial_responsible_params[:email])
    if @financial_responsible.save
      responsible = Responsible.new(student_id: @student.id, financial_responsible_id: @financial_responsible.id)
      if responsible.save
        redirect_to @financial_responsible, notice: t('.success')
      else
        flash.now[:alert] = 'Não foi possível criar o vinculo entre'
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

  def set_student
    @student = Student.find(params[:student_id])
  end
  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end

  def financial_responsible_params
    params.require(:financial_responsible).permit(:name, :phone, :cpf, :email, :student_id)
  end

  def set_responsible
    @financial_responsible = FinancialResponsible.find(params[:id])
  end
end
