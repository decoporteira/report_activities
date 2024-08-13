require 'rails_helper'

RSpec.describe "billings/index", type: :view do
  before(:each) do
    assign(:billings, [
      Billing.create!(
        name: "Name",
        email: "Email"
      ),
      Billing.create!(
        name: "Name",
        email: "Email"
      )
    ])
  end

  it "renders a list of billings" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
  end
end
