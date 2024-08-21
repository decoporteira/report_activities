class HomeController < ApplicationController
  def index
    case current_user.role
    when 'admin'
      redirect_to admin_home_path
    when 'teacher'
      redirect_to teacher_home_path
    when 'accounting'
      redirect_to accounting_home_path
    else
      set_info
      render 'index'
    end
  end

  private

  def set_info
    financial_responsible_blank
  end

  def financial_responsible_blank
    financial_responsible =
      FinancialResponsible
        .where(cpf: current_user.cpf)
        .or(FinancialResponsible.where(email: current_user.email))
        .first
    @students =
      if financial_responsible.blank?
        Student
          .where(cpf: current_user.cpf)
          .where
          .not(cpf: [nil, ''])
          .registered
          .includes([:classroom, { classroom: :teacher }])
      else
        financial_responsible.students.includes(
          [:classroom, { classroom: :teacher }]
        )
      end
  end
end
