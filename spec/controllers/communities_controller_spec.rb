require 'rails_helper'

RSpec.describe CommunitiesController, type: :controller do

  describe "GET #words" do
    it "returns http success" do
      get :words
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #questions" do
    it "returns http success" do
      get :questions
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #ranking" do
    it "returns http success" do
      get :ranking
      expect(response).to have_http_status(:success)
    end
  end

end
