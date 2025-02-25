require 'rails_helper'

RSpec.describe "material_billings/edit", type: :view do
  let(:material_billing) {
    MaterialBilling.create!(
      name: "MyString",
      status: 1,
      student: nil,
      value: "9.99"
    )
  }

  before(:each) do
    assign(:material_billing, material_billing)
  end

  it "renders the edit material_billing form" do
    render

    assert_select "form[action=?][method=?]", material_billing_path(material_billing), "post" do

      assert_select "input[name=?]", "material_billing[name]"

      assert_select "input[name=?]", "material_billing[status]"

      assert_select "input[name=?]", "material_billing[student_id]"

      assert_select "input[name=?]", "material_billing[value]"
    end
  end
end
