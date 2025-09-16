require 'rails_helper'

RSpec.describe 'Usuário cria aula particular' do
  it 'com sucesso' do
    user = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user_id: user.id, name: 'Ash')
    plan = FactoryBot.create(:plan, name: 'Particular', price: 330, billing_type: :per_class)
    student = FactoryBot.create(:student, name: 'Pikachu')
    FactoryBot.create(:current_plan, plan_id: plan.id, student_id: student.id, teacher_id: teacher.id )
    
    login_as(user)
    visit(root_path)
    click_on('Aulas Particulares')
    within(all('td.wday-5').first) do
      click_link 'Criar aula'
    end
    select 'Pikachu', from: 'private_lesson_current_plan_id'
    select '2', from: 'private_lesson_start_time_3i'
    select 'agosto', from: 'private_lesson_start_time_2i'
    select '11 AM', from: 'private_lesson_start_time_4i'
    fill_in 'private_lesson_notes', with: 'Aula de reposição'
    click_on 'Criar Private lesson'

    expect(page).to have_content('Aula particular criada com sucesso.')
    expect(page).to have_content('Aluno(a): Pikachu')
    expect(page).to have_content('Aula: 02/08')
    expect(page).to have_content('Horário: 11:00')
    expect(page).to have_content('Professor(a): Ash')
    expect(page).to have_content('Anotação: Aula de reposição')
  end
end