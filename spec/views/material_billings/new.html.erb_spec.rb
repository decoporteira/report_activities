require 'rails_helper'

RSpec.describe 'material_billings/new', type: :view do
  before(:each) do
    student = Student.create!(name: 'Pikachu', status: 'registered')
    assign(:material_billing, MaterialBilling.new(
                                name: 'MyString',
                                status: 1,
                                student:,
                                value: '9.99',
                                date: '2025-03-03'
                              ))
  end

  it 'renders new material_billing form' do
    render

    assert_select 'form[action=?][method=?]', material_billings_path, 'post' do
      assert_select 'input[name=?]', 'material_billing[name]'

      assert_select 'select[name=?]', 'material_billing[status]'

      assert_select 'input[name=?][type=hidden]', 'material_billing[student_id]'
      assert_select 'h2', /Aluno:/

      assert_select 'input[name=?]', 'material_billing[value]'
    end
  end
end
