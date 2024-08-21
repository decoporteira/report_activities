class TeachersController < ApplicationController
  before_action :set_teacher, only: %i[show edit update destroy info]
  before_action :authorize_admin!

  # GET /teachers or /teachers.json
  def index
    @teachers = Teacher.all
  end

  # GET /teachers/1 or /teachers/1.json
  def show; end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit; end

  # POST /teachers or /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to teacher_url(@teacher), notice: t('.success') }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html do
          render :new, status: :unprocessable_entity, notice: t('.fail')
        end
        format.json do
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /teachers/1 or /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to teacher_url(@teacher), notice: t('.success') }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html do
          render :edit, status: :unprocessable_entity, notice: t('.fail')
        end
        format.json do
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    return unless current_user.admin?

    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  def info; end

  private

  def authorize_admin!
    return if current_user.admin? || current_user.accounting?

    redirect_to root_path, alert: t('.denied')
  end

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end

  def teacher_params
    params
      .require(:teacher)
      .permit(:name, :status, :cpf, :user_id, :cel_phone, :phone)
  end
end
