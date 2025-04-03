require 'rails_helper'

RSpec.describe 'material_billings/edit', type: :view do
  let(:material_billing) do
    student = Student.create!(name: 'Pikachu', status: :registered)
    MaterialBilling.create!(
      name: 'MyString',
      status: 1,
      student:,
      value: '9.99',
      date: Time.zone.today
    )
  end

  before(:each) do
    assign(:material_billing, material_billing)
  end

  it 'renders the edit material_billing form' do
    render

    assert_select 'form[action=?][method=?]', material_billing_path(material_billing), 'post' do
      assert_select 'input[name=?]', 'material_billing[name]'

      assert_select 'select[name=?]', 'material_billing[status]'

      assert_select 'input[name=?]', 'material_billing[value]'
      if material_billing.student.present?
        assert_select 'input[name=?][type=hidden]', 'material_billing[student_id]'
        assert_select 'h2', /Aluno:/
      else
        assert_select 'select[name=?]', 'material_billing[student_id]'
      end
    end
  end
end
