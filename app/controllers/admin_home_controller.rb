class AdminHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]

  def index
    @classrooms =
      Classroom.includes(:students).where(students: { status: 'registered' })

    @students = Student.registered
  end

  private

  def check_authorization!
    return if current_user.admin?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
