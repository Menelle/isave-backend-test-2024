require 'rails_helper'

RSpec.describe "Api::V1::Portfolios", type: :request do
  let!(:customer){ create(:customer) }

  describe "GET /api/v1/portfolios" do
    it "works!" do
      get api_v1_portfolios_path
      expect(response).to have_http_status(200)
    end
  end
end
