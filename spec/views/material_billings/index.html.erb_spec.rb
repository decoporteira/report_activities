require 'rails_helper'

RSpec.describe 'material_billings/index', type: :view do
  before(:each) do
    student = create(:student, name: 'Pikachu', status: 'registered')
    student_two = create(:student, name: 'Raichu do Ash', status: 'registered')

    assign(:material_billings, [
             create(:material_billing, name: 'Books', status: 2, student:, value: '999', date: '2025-03-03'),
             create(:material_billing, name: 'Books', status: 2, student: student_two, value: '999',
                                       date: '2025-03-03')
           ])
  end

  it 'renders a list of material_billings' do
    render
    assert_select 'h4', text: 'Pikachu', count: 1
    assert_select 'h4', text: 'Raichu do Ash', count: 1
    assert_select 'p', text: /Detalhe: Books/, count: 2
    assert_select 'p', text: /Valor:\s*R\$ 999,00/, count: 2
  end
end
