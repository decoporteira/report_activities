class AttendancesController < ApplicationController

    def index
        @students = Student.all
        @attendances = Attendance.all
    end

    def update_attendance

        student = Student.find(params[:items][:student_id])
        classroom = Classroom.find(student.classroom_id)
        attendance_record = Attendance.find_or_initialize_by(student_id: student.id, attendance_date: params[:items][:date])
        if params[:items][:presence] == 'true'
            attendance_record.update(presence: false)
            redirect_to classroom_path(classroom), notice: "Presença marcada como Ausente."
        else
            attendance_record.update(presence: true)
            redirect_to classroom_path(classroom), notice: "Presença marcada como Presente."
        end
        

    end

    def show
        @student = Student.find(params[:id])
        @attendances = @student.attendances
    end

end