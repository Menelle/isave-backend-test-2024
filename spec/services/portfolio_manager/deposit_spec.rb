require 'rails_helper'

RSpec.describe PortfolioManager::Deposit, type: :service do
  subject(:service_instance){ described_class.new(portfolio:, investment:, amount:) }

  describe ".call" do
    let(:customer) { create(:customer) }
    let(:portfolio) { create(:portfolio_cto, customer:) }
    let(:instrument) { create(:stock) }
    let(:investment) { create(:investment, portfolio:, instrument:, amount: Money.new(500000, "EUR")) }
    let(:amount) { 10000 }

    it "updates the investment" do
      expect {
        service_instance.call
        investment.reload
    }.to change { investment.reload.amount.to_d }.by(10000)
    end

    it "updates the portfolio" do
      expect {
        service_instance.call
        portfolio.reload
      }.to change { portfolio.reload.amount.to_d }.by(10000)
    end

    it "succeeds" do
      expect(service_instance.call.success?).to be true
    end
  end

end
