class ApplicationController < ActionController::Base
  before_action :set_query
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_query
    @q = Student.ransack(params[:q])
    @student = @q.result(distinct: true)
  end

  protected

  def configure_permitted_parameters
    # User Update parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf])
    devise_parameter_sanitizer.permit(:account_update, keys: [:cpf])
  end
end
