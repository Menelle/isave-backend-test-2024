require 'rails_helper'

RSpec.describe PortfolioManager::Withdrawal, type: :service do
  subject(:service_instance){ described_class.new(portfolio:, investment:, amount:) }

  describe ".call" do
    let(:customer) { create(:customer) }
    let(:portfolio) { create(:portfolio_cto, customer:) }
    let(:instrument) { create(:stock) }
    let(:investment) { create(:investment, portfolio:, instrument:, amount: Money.new(500000, "EUR")) }

    context "with sufficient funds" do
      let(:amount) { 3000 }

      it "updates the investment" do
        expect {
          service_instance.call
          investment.reload
        }.to change { investment.reload.amount.to_d }.by(-3000)
      end

      it "updates the portfolio" do
        expect {
          service_instance.call
          portfolio.reload
        }.to change { portfolio.reload.amount.to_d }.by(-3000)
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
        expect(result.errors).to eq("Insufficient funds, available: €5,000.00")
      end
    end

  end

end