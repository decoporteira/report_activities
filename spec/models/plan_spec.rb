require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'Testa a criação de Planos' do
    expect { FactoryBot.create(:plan, name: 'Kids', price: 330) }.to change {
      Plan.count
    }.by(1)
  end

  it 'Testa a criação de Planos e falha' do
    expect { FactoryBot.create(:plan, name: '', price: 330) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
