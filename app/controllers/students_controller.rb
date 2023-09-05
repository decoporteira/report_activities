class StudentsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:show]
  before_action :set_student, only: %i[ show edit update destroy ]
  before_action :get_info
  
  
  require 'csv'
  
  def import
  
   return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
   return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

   opened_file = File.open(params[:file])
   csv = CSV.parse(opened_file, skip_blanks: true)
   
   headers = csv[0]
    
 
    csv.each_with_index do |value, index|
      if index.zero? 
        next
      else
        headers.each_with_index do |h, i|
        
        next if i == 0
          if value[0] == nil
            next
          elsif value[i] == nil
            value[i] = "Presente"
            current_student = create_student(h, params[:classroom_id])
            create_activity(current_student.id, value[i], value[0]) 
          else
            current_student = create_student(h, params[:classroom_id])
            create_activity(current_student.id, value[i], value[0]) 
          end
        end
      end
    end
 
   redirect_to request.referer, notice: 'Import started...'
  end
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
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students or /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to student_url(@student), notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1 or /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to student_url(@student), notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1 or /students/1.json
  def destroy
    @student.destroy

    respond_to do |format|
      format.html { redirect_to students_url, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
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
      params.require(:student).permit(:name, :status, :classroom_id, :cpf)
    end
end
