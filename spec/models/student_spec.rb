require 'rails_helper'

RSpec.describe Student, type: :model do
  it "Testa a criação de ClassRoom" do
    expect { FactoryBot.create(:student) }.to change { Student.count }.by(1)
  end
end
