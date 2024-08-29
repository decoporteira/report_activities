class CurrentPlansController < ApplicationController
  before_action :set_current_plan, only: %i[ show edit update destroy ]

  # GET /current_plans or /current_plans.json
  def index
    @current_plans = CurrentPlan.all
  end

  # GET /current_plans/1 or /current_plans/1.json
  def show
  end

  # GET /current_plans/new
  def new
    @current_plan = CurrentPlan.new
  end

  # GET /current_plans/1/edit
  def edit
  end

  # POST /current_plans or /current_plans.json
  def create

    @current_plan = CurrentPlan.new(current_plan_params)

    # if CurrentPlan.exists?(student_id: @current_plan.student_id)
    #   flash.now[:alert] = t('.fail')
    #   render :new, status: :unprocessable_entity
    #   return
    # end
    respond_to do |format|
      if @current_plan.save
        format.html { redirect_to current_plan_url(@current_plan), notice: t('.success')}
        format.json { render :show, status: :created, location: @current_plan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @current_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /current_plans/1 or /current_plans/1.json
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_plan
      @current_plan = CurrentPlan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def current_plan_params
      params.require(:current_plan).permit(:plan_id, :has_discount, :discount, :student_id)
    end
end