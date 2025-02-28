require 'rails_helper'

RSpec.describe 'material_billings/index', type: :view do
  before(:each) do
    student = Student.create!(name: 'Pikachu', status: 'registered')
    assign(:material_billings, [
             MaterialBilling.create!(
               name: 'Books',
               status: 2,
               student:,
               value: '9.99',
               date: '2025-03-03'
             ),
             MaterialBilling.create!(
               name: 'Books',
               status: 2,
               student:,
               value: '9.99',
               date: '2025-03-03'
             )
           ])
  end

  it 'renders a list of material_billings' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Pikachu'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('9.99'.to_s), count: 2
  end
end
