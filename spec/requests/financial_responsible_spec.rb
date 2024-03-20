require 'rails_helper'

RSpec.describe 'Usuário cadastra um responsável financeiro' do
  it 'e é do tipo default' do
    user_default = create(:user_two)
    login_as user_default, scope: :user
    post '/financial_responsibles', params: { financial_responsible: {  name: 'Oak',
                                                                        email: 'oak@email.com',
                                                                        phone: '00 0000-0000',
                                                                        cpf: '000.000.000-01' } }

    expect(FinancialResponsible.count).to eq 0
    expect(response).to redirect_to root_path
  end
end
