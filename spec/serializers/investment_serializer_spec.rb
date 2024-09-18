require 'rails_helper'

RSpec.describe InvestmentSerializer do
  subject(:serializer){  InvestmentSerializer.new(investment) }

  describe "#as_json" do
    let(:customer) { create(:customer) }
    let(:portfolio){ create(:portfolio_cto, customer: customer) }
    let(:instrument){ create(:stock) }
    let(:investment){ create(:investment, portfolio: portfolio, instrument: instrument) }

    it "includes the expected attributes" do
      expect(subject.as_json.keys).to contain_exactly(
        :type, :isin, :label, :price, :share, :amount, :srri
      )
    end
  end

end
