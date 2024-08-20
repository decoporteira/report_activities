require 'rails_helper'

RSpec.describe 'billings/edit', type: :view do
  let(:billing) { Billing.create!(name: 'MyString', email: 'MyString') }

  before(:each) { assign(:billing, billing) }

  it 'renders the edit billing form' do
    render

    assert_select 'form[action=?][method=?]', billing_path(billing), 'post' do
      assert_select 'input[name=?]', 'billing[name]'

      assert_select 'input[name=?]', 'billing[email]'
    end
  end
end
