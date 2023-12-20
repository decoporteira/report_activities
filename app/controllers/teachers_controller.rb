class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[ show edit update destroy ]
  before_action :authorize_admin!

  # GET /teachers or /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/1 or /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to teacher_url(@teacher), notice: "Teacher was successfully created." }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to teacher_url(@teacher), notice: "Teacher was successfully updated." }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1 or /teachers/1.json
  def destroy
    if current_user.admin?
      @teacher.destroy
      respond_to do |format|
        format.html { redirect_to teachers_url, notice: "Teacher was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: 'Você não tem permissão.'
    end
  end
   


  private
  def authorize_admin!
    redirect_to root_path, alert: 'Access denied.' unless current_user.admin? || current_user.teacher? || current_user.accounting?
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teacher_params
      params.require(:teacher).permit(:name, :status, :cpf, :user_id, :cel_phone, :phone)
    end
end
