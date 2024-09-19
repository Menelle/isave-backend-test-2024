require 'rails_helper'

RSpec.describe PortfolioManager::Transfer, type: :service do
  subject(:service_instance){ described_class.new(portfolio:, investment_from:, investment_to:, amount:) }

  describe ".call" do
    let(:customer) { create(:customer) }
    let(:portfolio) { create(:portfolio_cto, customer:) }
    let(:instrument_from) { create(:stock) }
    let(:instrument_to) { create(:stock) }
    let(:investment_from) { create(:investment, portfolio:, instrument: instrument_from, amount: Money.new(300000, "EUR")) }
    let(:investment_to) { create(:investment, portfolio:, instrument: instrument_to, amount: Money.new(500000, "EUR")) }

    context "with sufficient funds" do
      let(:amount) { 3000 }

      it "updates the source investment" do
        expect {
          service_instance.call
          investment_from.reload
        }.to change { investment_from.reload.amount.to_d }.by(-3000)
      end

      it "updates the target investment" do
        expect {
          service_instance.call
          investment_to.reload
        }.to change { investment_to.reload.amount.to_d }.by(3000)
      end

      it "updates the portfolio" do
        expect {
          service_instance.call
          portfolio.reload
        }.to change { portfolio.reload.amount.to_d }.by(0)
      end

      it "succeeds" do
        expect(service_instance.call.success?).to be true
      end
    end

    context "with insufficient funds" do
      let(:amount) { 100000 }

      it "fails" do
        result = service_instance.call
        expect(result.success?).to be false
        expect(result.errors).to eq("Insufficient funds, available: €3,000.00")
      end
    end

  end

end