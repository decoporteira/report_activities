require 'rails_helper'

RSpec.describe Classroom, type: :model do
  it 'Testa a criação de ClassRoom' do
    expect { FactoryBot.create(:classroom) }.to change { Classroom.count }.by(1)
  end
end
