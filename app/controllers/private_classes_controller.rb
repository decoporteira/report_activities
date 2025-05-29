class PrivateClassesController < ApplicationController
before_action :admin?
  def index
    @private_lessons = PrivateLesson.all
  end

  private
  def admin?
    return if current_user.admin? || current_user.accounting?

    redirect_to root_path, alert: t('unauthorized_action')
  end
end