require 'rails_helper'

RSpec.describe "Generations", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/generations/show"
      expect(response).to have_http_status(:success)
    end
  end

end
