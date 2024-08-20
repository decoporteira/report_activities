require 'rails_helper'

RSpec.describe 'billings/new', type: :view do
  before(:each) do
    assign(:billing, Billing.new(name: 'MyString', email: 'MyString'))
  end

  it 'renders new billing form' do
    render

    assert_select 'form[action=?][method=?]', billings_path, 'post' do
      assert_select 'input[name=?]', 'billing[name]'

      assert_select 'input[name=?]', 'billing[email]'
    end
  end
end
