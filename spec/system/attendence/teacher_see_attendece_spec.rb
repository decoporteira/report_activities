require 'rails_helper'

RSpec.describe 'User cria uma student' do
    it 'a partir do menu' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

        login_as(user)
        visit(root_path)
        click_on 'Attendances'

        expect(page).to have_content('Lista de Presença')

    end
end
