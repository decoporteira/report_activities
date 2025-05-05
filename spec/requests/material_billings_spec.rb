require 'rails_helper'

RSpec.describe '/material_billings', type: :request do
  let(:valid_attributes) do
    student = Student.create!(name: 'Pikachu Ash', status: 'registered')

    {
      name: 'Books',
      status: 'pending',
      student_id: student.id, # Passando o objeto `student` diretamente
      value: 9.99,
      date: Time.zone.today
    }
  end

  let(:invalid_attributes) do
    {
      name: 'Books',
      status: 'pending',
      student_id: Student.create!(name: 'Pikachu', status: 'registered'),
      value: 9.99,
      date: Time.zone.today
    }
  end
  let(:user) { User.create!(email: 'test@example.com', password: 'password', role: :admin) }
  describe 'GET /index' do
    it 'renders a successful response' do
      login_as user
      MaterialBilling.create! valid_attributes
      get material_billings_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      login_as user
      material_billing = MaterialBilling.create! valid_attributes
      get material_billing_url(material_billing)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      login_as user

      get new_material_billing_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      login_as user

      material_billing = MaterialBilling.create! valid_attributes
      get edit_material_billing_url(material_billing)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new MaterialBilling' do
        login_as user

        expect do
          post material_billings_url, params: { material_billing: valid_attributes }
        end.to change(MaterialBilling, :count).by(1)
      end

      it 'redirects to the created material_billing' do
        login_as user
        post material_billings_url, params: { material_billing: valid_attributes }
        expect(response).to redirect_to(material_billing_url(MaterialBilling.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new MaterialBilling' do
        login_as user
        expect do
          post material_billings_url, params: { material_billing: invalid_attributes }
        end.to change(MaterialBilling, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        login_as user
        post material_billings_url, params: { material_billing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested material_billing' do
        material_billing = MaterialBilling.create! valid_attributes
        patch material_billing_url(material_billing), params: { material_billing: new_attributes }
        material_billing.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the material_billing' do
        material_billing = MaterialBilling.create! valid_attributes
        patch material_billing_url(material_billing), params: { material_billing: new_attributes }
        material_billing.reload
        expect(response).to redirect_to(material_billing_url(material_billing))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        login_as user

        material_billing = MaterialBilling.create! valid_attributes
        patch material_billing_url(material_billing), params: { material_billing: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
