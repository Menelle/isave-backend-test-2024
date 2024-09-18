require 'rails_helper'

RSpec.describe PortfolioSerializer do
  subject(:serializer){  PortfolioSerializer.new(portfolio) }


  describe "#as_json" do
    let(:customer) { create(:customer) }

    context "when no investment" do
      let(:portfolio){ create(:portfolio_cto, customer: customer) }

      it "includes the expected attributes" do
        expect(subject.as_json.keys).to contain_exactly(
          :amount, :label, :type
        )
      end
    end

    context "when investments" do
      let(:portfolio){ create(:portfolio_cto, :with_investments, customer: customer) }

      it "includes the expected attributes" do
        expect(subject.as_json.keys).to contain_exactly(
          :amount, :label, :type, :lines
        )
      end
    end

  end

end
