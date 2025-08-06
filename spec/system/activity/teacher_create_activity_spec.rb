require 'rails_helper'

RSpec.describe 'teacher creates activity' do
  it 'a partir do menu com sucesso' do
    # arrange
    user =
      User.create!(
        email: 'bianca@teacher.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
        name: 'Oak',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.000.000-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.000.000-02'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '000.000.000-03'
    )

    # act
    login_as(user)
    visit(root_path)
    click_on('Enter Classroom')
    fill_in 'report', with: 'Cuspir fogo'
    fill_in 'Date', with: "02/#{Date.current.month}/#{Date.current.year}"
    select 'Feito', from: 'Late'
    click_on 'Criar atividade'

    # assert
    expect(page).to have_content('Atividades criadas com sucesso.')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Charmander')
    expect(page).to have_content('fogo (feito)')
    expect(page).not_to have_content('Blastoise')
  end

  it 'com sucesso' do
    # arrange
    user =
      User.create!(
        email: 'bianca@teacher.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom_two =
      Classroom.create!(name: 'MW 18:00', teacher_id: teacher.id, time: '24:00')

    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.000.000-01'
    )
    Student.create!(
      name: 'Bulbassaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.000.000-02'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '000.000.000-03'
    )
    Student.create!(
      name: 'Infernape',
      status: :registered,
      classroom_id: classroom_two.id,
      cpf: '000.000.000-04'
    )

    # act
    login_as(user)
    visit(classroom_path(classroom))
    fill_in 'report', with: 'Cuspir fogo'
    fill_in 'Date', with: "02/02/#{Date.current.year}"
    select 'Feito', from: 'Late'
    click_on 'Criar atividade'

    # assert
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Bulbassaur')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Cuspir fogo (feito)')
    expect(page).not_to have_content('Blastoise')
    expect(page).not_to have_content('Infernape')
  end
end
