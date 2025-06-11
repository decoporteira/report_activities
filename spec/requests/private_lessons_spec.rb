require 'rails_helper'

RSpec.describe "PrivateLessons", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:private_lesson) { FactoryBot.create(:private_lesson) }
  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get "/private_lessons/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/private_lessons/#{private_lesson.id}"
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
      get "/private_lessons/#{private_lesson.id}/edit"
      expect(response).to have_http_status(:success)
    end
  end
end
