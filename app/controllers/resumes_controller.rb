class ResumesController < ApplicationController
  before_action :set_student
  before_action :set_resume, only: %i[show edit update destroy]
  before_action :authorize_admin!

  def new
    @resume = Resume.new
  end

  def index
    @resumes = Resume.where(student_id: @student)
  end

  def show; end

  def edit; end

  def create
    @resume = Resume.new(resume_params)
    @resume.student_id = @student.id
    respond_to do |format|
      if @resume.save
        format.html do
          redirect_to @student, notice: 'Resume was successfully created.'
        end
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:alert] = 'Já existe um Relatório cadastrado.'
        format.json do
          render json: @resume.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @resume.update(resume_params)
        format.html do
          redirect_to @student, notice: 'Resume was successfully created.'
        end
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @resume.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @resume.destroy
    redirect_to student_resume_path(@student),
                notice: 'Relatório foi removido com sucesso.'
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def set_resume
    @resume = Resume.find(params[:id])
  end

  def resume_params
    params.require(:resume).permit(:written_report, :date, :status, :student_id)
  end

  def authorize_admin!
    return if current_user.admin? || current_user.accounting? || current_user.teacher?

    redirect_to root_path, alert: 'Access denied.'
  end
end
