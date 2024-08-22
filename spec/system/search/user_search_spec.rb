require 'rails_helper'

RSpec.describe 'Usuário pesquisa' do
  it 'E não vê nenhum resultado' do
    user =
      User.create!(
        email: 'admin@emailcom.br',
        password: 'password',
        role: 'admin'
      )

    login_as user
    visit root_path

    fill_in 'search', with: 'Deco'
    click_on 'Search'

    expect(page).to have_content 'Alunos encontrados: 0'
    expect(current_path).to eq search_index_path
  end

  it 'E vê resultados de alunos e turmas' do
    user =
      User.create!(
        email: 'admin@emailcom.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom =
      Classroom.create!(
        name: 'Sala dos Chamanders e evoluções',
        teacher_id: teacher.id,
        time: '11:00'
      )
    Student.create!(
      name: 'Chameleon',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )

    login_as user
    visit root_path

    fill_in 'search', with: 'cha'
    click_on 'Search'

    expect(page).to have_content 'Alunos encontrados: 2'
    expect(page).to have_content 'Charmander'
    expect(page).to have_content 'Chameleon'
    expect(page).to have_content 'Turmas encontradas: 1'
    expect(page).to have_content 'Sala dos Chamanders e evoluções'
    expect(page).to_not have_content 'MW 17:00'
    expect(page).to_not have_content 'Blastoise'
  end

  it 'E vê filtro de professores' do
    user =
      User.create!(
        email: 'admin@email.com.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@email.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Carvalho',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    user_teacher_two =
      User.create!(
        email: 'teacher_two@email.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher_two =
      Teacher.create!(
        name: 'Oak',
        status: 'disponível',
        user_id: user_teacher_two.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom =
      Classroom.create!(name: 'MW 13:00', teacher_id: teacher.id, time: '23:00')
    classroom_two =
      Classroom.create!(
        name: 'MW 19:00',
        teacher_id: teacher_two.id,
        time: '11:00'
      )
    Student.create!(
      name: 'Chameleon',
      status: :registered,
      classroom_id: classroom_two.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )

    login_as user
    visit root_path

    fill_in 'search', with: 'MW'
    click_on 'Search'

    expect(page).to have_content 'Alunos encontrados: 0'
    expect(page).to have_content 'Turmas encontradas: 3'
    expect(page).to have_content 'MW 17:00'
    expect(page).to have_content 'Professor(a): Oak'
    expect(page).to have_content 'Professor(a): Carvalho'
    expect(page).to have_content 'Turmas de Oak'
    expect(page).to have_content 'Turmas de Carvalho'
  end

  it 'E vê filtro de professores e clica em um professor' do
    user =
      User.create!(
        email: 'admin@email.com.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@email.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Carvalho',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    user_teacher_two =
      User.create!(
        email: 'teacher_two@email.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher_two =
      Teacher.create!(
        name: 'Oak',
        status: 'disponível',
        user_id: user_teacher_two.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom =
      Classroom.create!(name: 'MW 13:00', teacher_id: teacher.id, time: '23:00')
    classroom_two =
      Classroom.create!(
        name: 'MW 19:00',
        teacher_id: teacher_two.id,
        time: '11:00'
      )
    Student.create!(
      name: 'Chameleon',
      status: :registered,
      classroom_id: classroom_two.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )

    login_as user
    visit root_path

    fill_in 'search', with: 'MW'
    click_on 'Search'
    click_on 'Turmas de Carvalho'

    expect(page).to have_content 'Turmas encontradas: 2'
    expect(page).not_to have_content 'MW 19:00'
    expect(page).to have_content 'MW 17:00'
    expect(page).to have_content 'MW 13:00'
    expect(page).not_to have_content 'Professor(a): Oak'
    expect(page).to have_content 'Professor(a): Carvalho'
  end

  it 'E vê resultados de alunos com acento' do
    user =
      User.create!(
        email: 'admin@emailcom.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Charmeléon',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    Student.create!(
      name: 'Blastoise',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )

    login_as user
    visit root_path

    fill_in 'search', with: 'Charmeleon'
    click_on 'Search'

    expect(page).to have_content 'Alunos encontrados: 1'
    expect(page).to have_content 'Charmeléon'
    expect(page).to have_content 'Turmas encontradas: 0'
  end
end
