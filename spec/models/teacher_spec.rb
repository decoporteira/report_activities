require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it 'Testa a criação de Teacher' do
    expect { FactoryBot.create(:teacher) }.to change { Teacher.count }.by(1)
  end
  it 'Testa a criação de Teacher com nome inválido' do
    expect do
      FactoryBot.create(:teacher2)
    end.to raise_error(ActiveRecord::RecordInvalid,
                       'A validação falhou: Nome não pode ficar em branco')
  end
end
