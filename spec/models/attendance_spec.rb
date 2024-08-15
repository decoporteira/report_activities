require 'rails_helper'

RSpec.describe Attendance, type: :model do
  it 'Testa a criação de Attendance' do
    user = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student = Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                              cpf: '000.097.098-01')
    Attendance.create!(student_id: student.id, attendance_date: '2023-05-05', presence: false)
    Attendance.find_or_create_by!(student_id: student.id, attendance_date: '2023-05-05', presence: true)
    date = '2023-05-05'
    expect { Attendance.create!(student_id: student.id, attendance_date: date) }.to change { Attendance.count }.by(1)
  end
end
