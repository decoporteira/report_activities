class HomeController < ApplicationController
  def index
    if current_user.default?
      financial_responsible_blank
    elsif current_user.teacher?
      @classrooms = Classroom.includes(:teacher).where(teacher_id: current_user.teacher.id)
    else
      @classrooms = Classroom.includes(:students).where(students: { status: 'registered' })

      @students = Student.registered
    end
  end

  private

  def financial_responsible_blank
    financial_responsible = FinancialResponsible.where(cpf: current_user.cpf).or(FinancialResponsible.where(email: current_user.email)).first
    @students = if financial_responsible.blank?
                  Student.where(cpf: current_user.cpf)
                                      .where.not(cpf: [nil, ''])
                                      .registered
                                      .includes([:classroom, classroom: :teacher])
                else
                  financial_responsible.students.includes([:classroom, classroom: :teacher])
                end
  end
end
