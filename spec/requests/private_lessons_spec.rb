require 'rails_helper'

RSpec.describe "PrivateLessons", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/private_lessons/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/private_lessons/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/private_lessons/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/private_lessons/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
