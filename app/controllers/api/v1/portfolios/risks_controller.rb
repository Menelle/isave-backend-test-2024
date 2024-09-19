class Api::V1::Portfolios::RisksController < Api::V1::ApplicationController

  before_action :set_portfolios, only: %i(index)


  # NOTE: I want to see the risk level of each portfolio, so I know how much risk I'm taking on each set of investments
  # NOTE: I want to know the overall risk I'm taking by considering all my portfolios, so I can get a complete picture of my financial risks
  def index
    result =
      if params[:ids].present?
        ActiveModel::Serializer::CollectionSerializer.new(
          @portfolios,
          serializer: PortfolioRiskSerializer,
        )
      else
        { amount: Portfolio.total_amount(@portfolios), risk: Portfolio.total_risk_level(@portfolios) }
      end
  render json: result.as_json
  end

  private

  def set_portfolios
    @portfolios ||=
      current_customer.portfolios.investing.includes(investments: :instrument).yield_self{ |relation|
        params[:ids].present? ? relation.where(id: params[:ids].split(",")) : relation
      }
  end

end
