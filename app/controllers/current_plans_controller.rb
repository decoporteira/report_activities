class CurrentPlansController < ApplicationController
  before_action :authorize_admin!, only: %i[new index show edit]
  before_action :set_current_plan, only: %i[show edit update destroy]

  # GET /current_plans or /current_plans.json
  def index
    @current_plans = CurrentPlan.joins(:student).merge(Student.active).order('students.name')
    @students = Student.active.includes(:current_plan)

    plan_counts = @students.joins(current_plan: :plan).group('plans.name').count

    @kids = plan_counts['Kids'] || 0
    @teens = plan_counts['Teens'] || 0
    @adults = plan_counts['Adults'] || 0
    @privates = plan_counts['Particular'] || 0
  end

  # GET /current_plans/1 or /current_plans/1.json
  def show; end

  # GET /current_plans/new
  def new
    @current_plan = CurrentPlan.new(student_id: params[:student_id])
  end

  # GET /current_plans/1/edit
  def edit; end

  def create
    @current_plan = CurrentPlan.new(current_plan_params)
    respond_to do |format|
      if @current_plan.save
        format.html { redirect_to current_plan_url(@current_plan), notice: t('.success') }
        format.json { render :show, status: :created, location: @current_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @current_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @current_plan.update(current_plan_params)
        format.html { redirect_to current_plan_url(@current_plan), notice: t('.success') }
        format.json { render :show, status: :ok, location: @current_plan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @current_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /current_plans/1 or /current_plans/1.json
  def destroy
    @current_plan.destroy

    respond_to do |format|
      format.html { redirect_to current_plans_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def not_have_plan
    @students_without_current_plan = Student.includes(:current_plan).where(current_plans: { id: nil }).active
  end

  private

  def fetch_students_by_plan_name(plan_name)
    Student.joins(:current_plan)
           .active
           .where(current_plans: { plan_id: Plan.where(name: plan_name).pluck(:id) })
  end

  def set_current_plan
    @current_plan = CurrentPlan.find(params[:id])
  end

  def current_plan_params
    params.require(:current_plan).permit(:plan_id, :has_discount, :discount, :student_id)
  end

  def authorize_admin!
    redirect_to root_path, alert: t('.denied') unless current_user.admin? || current_user.accounting?
  end
end
