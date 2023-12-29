require 'rails_helper'

RSpec.describe 'user creates new Address' do
    it 'sucess' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '000.097.098-01')

        #act
        login_as(user)
        visit(root_path)
        find('#details').click
        click_on('Cadastrar Endereço')
        fill_in 'Rua', with: 'Rua das Coves'
        fill_in 'Número', with: '23'
        fill_in 'Complemento', with: 'apto 203'
        fill_in 'Bairro', with: 'Santos Dumont'
        fill_in 'Cidade', with: 'Juiz de Fora'
        fill_in 'Estado', with: 'MG'
        fill_in 'País', with: 'Brasil'
        fill_in 'CEP', with: '36038-030'
        click_on('Criar Endereço')
        #assert
        expect(page).to have_content('Venossaur')
        expect(page).to have_content('MW 17:00')
        expect(page).to have_content("Endereço cadastrado com sucesso.")
    end
end