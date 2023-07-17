require 'rails_helper'

RSpec.describe Activity, type: :model do
  it "Testa a criação de ClassRoom" do
    expect { FactoryBot.create(:activity) }.to change { Activity.count }.by(1)
  end
end
