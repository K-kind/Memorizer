require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  describe 'GET #top' do
    it 'returns http success' do
      get :top
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #about' do
    it 'returns http success' do
      get :about
      expect(response).to have_http_status(:success)
    end
  end
end
