class UsersController < ApplicationController
  before_action :authorize_admin!

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit; end

  private

  def authorize_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin?
  end
end
