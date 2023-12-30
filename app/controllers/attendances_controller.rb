class AttendancesController < ApplicationController

    def index
        @students = Student.all
        @attendances = Attendance.all
    end

    def update_attendance_to_false
        attendances = Attendance.where(student_id: params[:items][:student_id], attendance_date: params[:items][:date])
        attendances.each do |item|
          item.update(presence: false)
        end
        student = Student.find(params[:items][:student_id])
        classroom = Classroom.find(student.classroom_id)
        redirect_to classroom, notice: "Presença marcada como Ausente."
    end

    def show
        @student = Student.find(params[:id])
        @attendances = @student.attendances
    end

end