class MaterialBillingsController < ApplicationController
  before_action :set_material_billing, only: %i[ show edit update destroy ]

  # GET /material_billings or /material_billings.json
  def index
    @material_billings = MaterialBilling.all
  end

  # GET /material_billings/1 or /material_billings/1.json
  def show
  end

  # GET /material_billings/new
  def new
    @material_billing = MaterialBilling.new
  end

  # GET /material_billings/1/edit
  def edit
  end

  # POST /material_billings or /material_billings.json
  def create
    @material_billing = MaterialBilling.new(material_billing_params)

    respond_to do |format|
      if @material_billing.save
        format.html { redirect_to material_billing_url(@material_billing), notice: "Material billing was successfully created." }
        format.json { render :show, status: :created, location: @material_billing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @material_billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /material_billings/1 or /material_billings/1.json
  def update
    respond_to do |format|
      if @material_billing.update(material_billing_params)
        format.html { redirect_to material_billing_url(@material_billing), notice: "Material billing was successfully updated." }
        format.json { render :show, status: :ok, location: @material_billing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @material_billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /material_billings/1 or /material_billings/1.json
  def destroy
    @material_billing.destroy

    respond_to do |format|
      format.html { redirect_to material_billings_url, notice: "Material billing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material_billing
      @material_billing = MaterialBilling.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def material_billing_params
      params.require(:material_billing).permit(:name, :status, :student_id, :date, :value)
    end
end
