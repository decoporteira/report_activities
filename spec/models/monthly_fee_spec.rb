require 'rails_helper'

RSpec.describe MonthlyFee, type: :model do
  it 'Testa a criação de Mensalidade' do
    expect { FactoryBot.create(:monthly_fee) }.to change {
      MonthlyFee.count
    }.by(1)
  end
end
