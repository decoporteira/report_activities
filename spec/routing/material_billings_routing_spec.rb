require 'rails_helper'

RSpec.describe MaterialBillingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/material_billings').to route_to('material_billings#index')
    end

    it 'routes to #new' do
      expect(get: '/material_billings/new').to route_to('material_billings#new')
    end

    it 'routes to #show' do
      expect(get: '/material_billings/1').to route_to('material_billings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/material_billings/1/edit').to route_to('material_billings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/material_billings').to route_to('material_billings#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/material_billings/1').to route_to('material_billings#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/material_billings/1').to route_to('material_billings#update', id: '1')
    end

    # it "routes to #destroy" do
    #   expect(delete: "/material_billings/1").to route_to("material_billings#destroy", id: "1")
    # end
  end
end
