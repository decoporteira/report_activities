require 'rails_helper'

RSpec.describe 'Teachers', type: :request do
  it 'Apaga um professor' do
    admin = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    login_as(admin)

    expect { delete "/teachers/#{teacher.id}" }.to change(Teacher, :count).by(-1)
    expect(flash[:notice]).to eq('Teacher was successfully destroyed.')
  end

  it 'falha ao tentar apagar um professor' do
    User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    login_as(teacher_user)

    expect { delete "/teachers/#{teacher.id}" }.to change(Teacher, :count).by(0)
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Access denied.')
  end
end
