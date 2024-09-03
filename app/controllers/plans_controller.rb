class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :admin?

  def index
    @plans = Plan.all
  end

  def show
  end

  def new
    @plan = Plan.new
  end

  def edit
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to @plan, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to @plan, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to plans_url, notice: t('.success')
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :price)
  end

  def admin?
    return if current_user.admin? || current_user.accounting?

    redirect_to root_path, alert: t('unauthorized_action')
  end
end
