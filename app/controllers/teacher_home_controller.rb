class TeacherHomeController < ApplicationController
  before_action :check_authorization!, only: %i[index]
  def index
    @classrooms =
      Classroom.includes(:teacher).where(teacher_id: current_user.teacher.id)
  end

  private

  def check_authorization!
    return if current_user.teacher?

    redirect_to root_path, alert: t('Sem permissão para acessar essa página.')
  end
end
