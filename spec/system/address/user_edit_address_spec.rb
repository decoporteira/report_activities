require 'rails_helper'

RSpec.describe 'user edit address' do
    it 'sucess' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '000.097.098-01')
        address = Address.create!(street: 'Rua das Covas', number: '23', unit: '232', neighborhood: 'Santos Dumont', city: 'Juiz de Fora', state: 'MG', country: 'Brasil', zip_code: '34050-098', student_id: student.id)
        #act
        login_as(user)
        visit(root_path)
        find('#details').click
        click_on('Editar')
        fill_in 'Rua', with: 'Rua dos Alfaces'
        click_on('Update Endereço')
        
        #assert
        expect(page).to have_content('Venossaur')
        expect(page).to have_content('MW 17:00')
        expect(page).to have_content("Rua dos Alfaces")
        expect(page).to have_content("Número: 23")
        expect(page).to have_content("Complemento: 232")
        expect(page).to have_content("Bairro: Santos Dumont")
        expect(page).to have_content("Cidade: Juiz de Fora")
        expect(page).to have_content("Estado: MG")
        expect(page).to have_content("País: Brasil")
        expect(page).to have_content("CEP: 34050-098")
    end
end