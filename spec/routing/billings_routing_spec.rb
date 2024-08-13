require "rails_helper"

RSpec.describe BillingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/billings").to route_to("billings#index")
    end

    it "routes to #new" do
      expect(get: "/billings/new").to route_to("billings#new")
    end

    it "routes to #show" do
      expect(get: "/billings/1").to route_to("billings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/billings/1/edit").to route_to("billings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/billings").to route_to("billings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/billings/1").to route_to("billings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/billings/1").to route_to("billings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/billings/1").to route_to("billings#destroy", id: "1")
    end
  end
end
