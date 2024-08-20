require 'rails_helper'

RSpec.describe 'Usuário cadastra um responsável financeiro' do
  it 'com sucesso' do
    user_admin = create(:user, email: 'teste@email.com')
    login_as user_admin, scope: :user
    create(:student)
    post '/financial_responsibles',
         params: {
           financial_responsible: {
             name: 'Oak',
             email: 'oak@email.com',
             phone: '00 0000-0000',
             cpf: '000.000.000-01',
             student_id: 1
           }
         }

    expect(FinancialResponsible.count).to eq 1
  end

  it 'e é do tipo default' do
    user_default = create(:user_two)
    create(:student)
    login_as user_default, scope: :user
    post '/financial_responsibles',
         params: {
           financial_responsible: {
             name: 'Oak',
             email: 'oak@email.com',
             phone: '00 0000-0000',
             cpf: '000.000.000-01'
           }
         }

    expect(FinancialResponsible.count).to eq 0
    expect(response).to redirect_to root_path
  end

  it 'e é do tipo teacher' do
    user_teacher = create(:user_two, role: 'teacher')
    login_as user_teacher, scope: :user
    post '/financial_responsibles',
         params: {
           financial_responsible: {
             name: 'Oak',
             email: 'oak@email.com',
             phone: '00 0000-0000',
             cpf: '000.000.000-01'
           }
         }

    expect(FinancialResponsible.count).to eq 0
    expect(response).to redirect_to root_path
  end
end
