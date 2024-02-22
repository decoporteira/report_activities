require 'rails_helper'

RSpec.describe 'Usuário tenta acessar área administrativa' do
  it 'é professor' do
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')

    login_as(user_teacher)
    visit(rails_admin_path)

    expect(current_path).to eq root_path
  end
end
