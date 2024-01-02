class StudentsController < ApplicationController
  before_action :cant_see, only: [:show, :info]
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_student, only: [ :show, :edit, :update, :destroy, :info, :show_2023]
  before_action :get_info
  

 # final do import 
  def create_student(name, classroom_id)
    Student.find_or_create_by!(name: name, status: 1, classroom_id: classroom_id )
  end

  def create_activity(student_id, report, date)
    date = date + "/2023"
    Activity.create!(student_id: student_id , report: report, date: date, late: 0)
  end

  # GET /students or /students.json
  def index
    @students = Student.all
  end

  # GET /students/1 or /students/1.json
  def show
    if current_user.student? && @student.cpf != current_user.cpf
      return redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
    end
    if params[:year].to_i == 2023
      @activities = @student.activities.where('date <= ?', Date.new(2023, 12, 31)).order(:date)
      @resume = @student.resumes.find_by("strftime('%Y', created_at) = ?", '2023')

    else
      @activities = @student.activities.where('date >= ?', Date.new(2024, 1, 1)).order(:date)
      @resume = @student.resumes.find_by("strftime('%Y', created_at) = ?", '2024')

    end
   
    @dates_with_actitivies = []
    @activities.each do |activity| 
      @dates_with_actitivies << activity.date
    end
   @student
   @number_of_days = @dates_with_actitivies.uniq.length
  
   @number_of_absence = @student.attendances.where(presence: false).where('attendance_date >= ?', Date.new(2024, 1, 1)).length
   @attendance_rate = @number_of_days
   
  end

  def show_2023
    if current_user.student? && @student.cpf != current_user.cpf
      return redirect_to root_path, alert: 'Você não possui acesso a esse aluno.'
    end

    @activities = @student.activities.sort_by(&:date)
    @dates_with_actitivies = []
    @activities.each do |activity| 
      @dates_with_actitivies << activity.date
    end
   @student
   @number_of_days = @dates_with_actitivies.uniq.length
  
   @number_of_absence = @student.attendances.where(presence: false).length
   @attendance_rate = @number_of_days
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
    if current_user.student?
      redirect_to root_path
    end
  end

  # POST /students or /students.json
  def create
    if current_user.admin? || current_user.accounting? 
      @student = Student.new(student_params)
      respond_to do |format|
        if @student.save
          format.html { redirect_to info_student_path(@student), notice: "Student was successfully created." }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Você não tem permissão para cadastrar novos alunos.'
    end
    
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to info_student_path(@student), notice: "Student was successfully updated." }
        format.json { render :info, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    if current_user.admin?
      @student.destroy
      respond_to do |format|
        format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: 'Você não tem permissão.'
    end
  end

  def info
    if current_user.student?
      redirect_to root_path
    end
  end

  def not_registered
    @students = Student.where(status: 'Não matriculado')
  end

  private

  def get_info
    @activities = Activity.where(:student_id=> params[:id])
  end
    # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def student_params
    params.require(:student).permit(:name, :status, :classroom_id, :cpf, :phone, :cel_phone)
  end

  def cant_see
    @student = Student.find(params[:id])
    if current_user.student?
      redirect_to root_path unless @student.cpf == current_user.cpf
    end
  end
 
end
