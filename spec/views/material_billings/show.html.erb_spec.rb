require 'rails_helper'

RSpec.describe 'material_billings/show', type: :view do
  before(:each) do
    student = Student.create!(name: 'Pikachu', status: 'registered')
    assign(:material_billing, MaterialBilling.create!(
                                name: 'Name',
                                status: 2,
                                student:,
                                value: '9.99',
                                date: Time.zone.today
                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
