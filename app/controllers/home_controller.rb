class HomeController < ApplicationController

  def index
    if current_user.default?
      financial_responsible = FinancialResponsible.where(cpf: current_user.cpf).or(FinancialResponsible.where(email: current_user.email)).first
      if financial_responsible.blank?
        @students = Student.where(cpf: current_user.cpf).where.not(cpf: [nil, '']).registered
      else
        @students = financial_responsible.students
      end
    elsif current_user.teacher?
      @classrooms = Classroom.includes(:students).where(teacher_id: current_user.teacher.id)
    else
      @classrooms = Classroom.includes(:students).where(students: { status: 'registered' })

      @students = Student.registered
    end
  end
end
