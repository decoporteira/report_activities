require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it "Testa a criação de Teacher" do
    expect { FactoryBot.create(:teacher) }.to change { Teacher.count }.by(1)
  end
end
