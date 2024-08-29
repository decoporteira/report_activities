require "rails_helper"

RSpec.describe CurrentPlansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/current_plans").to route_to("current_plans#index")
    end

    it "routes to #new" do
      expect(get: "/current_plans/new").to route_to("current_plans#new")
    end

    it "routes to #show" do
      expect(get: "/current_plans/1").to route_to("current_plans#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/current_plans/1/edit").to route_to("current_plans#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/current_plans").to route_to("current_plans#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/current_plans/1").to route_to("current_plans#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/current_plans/1").to route_to("current_plans#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/current_plans/1").to route_to("current_plans#destroy", id: "1")
    end
  end
end
