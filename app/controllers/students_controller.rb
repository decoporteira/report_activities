class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]
  
  require 'csv'
  
  def import
  
   return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
   return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

   opened_file = File.open(params[:file])
   csv = CSV.parse(opened_file)
   
   headers = csv[0]
    #  p"----------------------------------------------------------------------------"
    #  p params[:classroom_id]
    #  p"----------------------------------------------------------------------------"
    #Student.create!(date: value[0], name: h, report: value[i])
 
   csv.each_with_index do |value, index|
     if index.zero?
       next
     else
       headers.each_with_index do |h, i|
         next if i == 0
          p"----------------------------------------------------------------------------"
           p value[0] + "/23"
           p"----------------------------------------------------------------------------"
        current_student = Student.create!(name: h, status: 1, classroom_id: params[:classroom_id] )
        Activity.create!(student_id: current_student.id , report: value[i], date: value[0] + "/2023", late: 0)
       end
     end
   end
 
   redirect_to request.referer, notice: 'Import started...'
 end
 # final do import 

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
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.require(:student).permit(:name, :status, :classroom_id)
    end
end
