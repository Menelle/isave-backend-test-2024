require 'rails_helper'

RSpec.describe "Api::V1::Portfolios", type: :request do
  let!(:customer){ create(:customer) }

  describe "GET /api/v1/portfolios" do
    it "works!" do
      get api_v1_portfolios_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /api/v1/portfolios/id/withdrawal" do
    let(:customer){ create(:customer) }
    let(:instrument) { create(:stock) }
    let(:investment) { create(:investment, portfolio:, instrument:, amount: Money.new(500000, "EUR")) }

    context "with cto" do
      let(:portfolio){ create(:portfolio_cto, customer:) }

      scenario "sufficient funds" do
        post withdrawal_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end

      scenario "insufficient funds" do
        post withdrawal_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 10000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Insufficient funds, available: €5,000.00" }.to_json)
      end
    end

    context "with pea" do
      let(:portfolio){ create(:portfolio_pea, customer:) }

      scenario "sufficient funds" do
        post withdrawal_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end

      scenario "insufficient funds" do
        post withdrawal_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 10000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Insufficient funds, available: €5,000.00" }.to_json)
      end
    end

    context "with assurance_vie" do
      let(:portfolio){ create(:portfolio_assurance_vie, customer:) }

      it "forbids" do
        post withdrawal_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Forbidden - The resource requested is not accessible" }.to_json)
      end
    end
  end

  describe "POST /api/v1/portfolios/id/deposit" do
    let(:customer){ create(:customer) }
    let(:instrument) { create(:stock) }
    let(:investment) { create(:investment, portfolio:, instrument:, amount: Money.new(500000, "EUR")) }

    context "with cto" do
      let(:portfolio){ create(:portfolio_cto, customer:) }

      it "works" do
        post deposit_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end
    end

    context "with pea" do
      let(:portfolio){ create(:portfolio_pea, customer:) }

      it "works" do
        post deposit_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end
    end

    context "with assurance_vie" do
      let(:portfolio){ create(:portfolio_assurance_vie, customer:) }

      it "forbids" do
        post deposit_api_v1_portfolio_path(id: portfolio.id), params: { investment_id: investment.id, amount: 1000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Forbidden - The resource requested is not accessible" }.to_json)
      end
    end

  end

  describe "POST /api/v1/portfolios/id/transfer" do
    let(:customer){ create(:customer) }
    let(:instrument_from) { create(:stock) }
    let(:instrument_to) { create(:stock) }
    let(:investment_from) { create(:investment, portfolio:, instrument: instrument_from, amount: Money.new(300000, "EUR")) }
    let(:investment_to) { create(:investment, portfolio:, instrument: instrument_to, amount: Money.new(500000, "EUR")) }

    context "with cto" do
      let(:portfolio){ create(:portfolio_cto, customer:) }

      scenario "sufficient funds" do
        post transfer_api_v1_portfolio_path(id: portfolio.id), params: { investment_from_id: investment_from.id, investment_to_id: investment_to.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end

      scenario "insufficient funds" do
        post transfer_api_v1_portfolio_path(id: portfolio.id), params: { investment_from_id: investment_from.id, investment_to_id: investment_to.id, amount: 1000000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Insufficient funds, available: €3,000.00" }.to_json)
      end
    end

    context "with pea" do
      let(:portfolio){ create(:portfolio_pea, customer:) }

      scenario "sufficient funds" do
        post transfer_api_v1_portfolio_path(id: portfolio.id), params: { investment_from_id: investment_from.id, investment_to_id: investment_to.id, amount: 1000 }
        expect(response).to have_http_status(201)
        expect(response.body).to eq({ success: true }.to_json)
      end

      scenario "insufficient funds" do
        post transfer_api_v1_portfolio_path(id: portfolio.id), params: { investment_from_id: investment_from.id, investment_to_id: investment_to.id, amount: 1000000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Insufficient funds, available: €3,000.00" }.to_json)
      end
    end

    context "with assurance_vie" do
      let(:portfolio){ create(:portfolio_assurance_vie, customer:) }

      it "forbids" do
        post transfer_api_v1_portfolio_path(id: portfolio.id), params: { investment_from_id: investment_from.id, investment_to_id: investment_to.id, amount: 1000 }
        expect(response).to have_http_status(403)
        expect(response.body).to eq({ success: false, errors: "Forbidden - The resource requested is not accessible" }.to_json)
      end
    end
  end

end
