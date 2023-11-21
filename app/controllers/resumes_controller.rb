class ResumesController < ApplicationController
  before_action :set_student
  before_action :set_resume, only: [:show, :edit, :update]

  def new
      @resume = Resume.new
  end

  def index
    p @student
    @resumes = Resume.where(student_id: @student)
  end
  
  def show
  end

  def edit
  end

  def create
    @resume = Resume.new(resume_params)
    @resume.student_id = @student.id
    respond_to do |format|
      if @resume.save
        format.html { redirect_to @student, notice: "Resume was successfully created." }
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @resume.update(resume_params)
        format.html { redirect_to @student, notice: "Resume was successfully created." }
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
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
end