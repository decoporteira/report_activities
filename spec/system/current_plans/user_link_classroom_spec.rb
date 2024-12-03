require 'rails_helper'

RSpec.describe 'Usuário linka uma turma toda por vez' do
  it 'com sucesso' do
    admin = FactoryBot.create(:user, role: 'admin')
    FactoryBot.create(:plan, id: 1)
    FactoryBot.create(:plan, name: 'Teens', price: 350)
    classroom = FactoryBot.create(:classroom)
    student_a =
      FactoryBot.create(:student, name: 'Pikachu', classroom: classroom)
    student_b = FactoryBot.create(:student, classroom: classroom)
    student_c = FactoryBot.create(:student, classroom: nil)

    login_as(admin)
    visit(root_path)
    click_on('Turmas')
    click_on('Linkar Kids')

    expect(page).to have_content('Cursos dos alunos alterado com sucesso.')
    expect(student_a.current_plan.plan.name).to eq('Kids')
    expect(student_b.current_plan.plan.name).to eq('Kids')
    expect(student_c.current_plan).to be_nil
    expect(page).to have_content('Cursos dos alunos alterado com sucesso.')
  end

  it 'erro caso aluno não esteja matriculado' do
    admin = FactoryBot.create(:user, role: 'admin')
    FactoryBot.create(:plan, id: 1)
    FactoryBot.create(:plan, name: 'Teens', price: 350)
    classroom = FactoryBot.create(:classroom)
    student_a =
      FactoryBot.create(:student, name: 'Pikachu', classroom: classroom)
    student_b =
      FactoryBot.create(
        :student,
        classroom: classroom,
        name: 'Charmander',
        status: :unregistered
      )
    student_c = FactoryBot.create(:student, classroom: nil)

    login_as(admin)
    visit(root_path)
    click_on('Turmas')
    click_on('Linkar Kids')

    expect(page).to have_content('Erros: Charmander: não está matriculado')
    expect(student_a.current_plan.plan.name).to eq('Kids')
    expect(student_b.current_plan).to be_nil
    expect(student_c.current_plan).to be_nil
  end
end
