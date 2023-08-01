require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it "Testa a criação de Teacher" do
    expect { FactoryBot.create(:teacher) }.to change { Teacher.count }.by(1)
  end
  it "Testa a criação de Teacher com nome inválido" do
    expect { FactoryBot.create(:teacher2) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
end
