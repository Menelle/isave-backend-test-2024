class Api::V1::Portfolios::FeesController < Api::V1::ApplicationController

  before_action :set_portfolios, only: %i(index)


  # NOTE: The current amount of fees applied to each of my portfolios.
  # NOTE: The current percentage of fees applied to each of my portfolios.
  # NOTE: The above values, but globally on all my investments.
  def index
    result =
      if params[:ids].present?
        ActiveModel::Serializer::CollectionSerializer.new(
          @portfolios,
          serializer: PortfolioFeeSerializer,
        )
      else
        { amount: Portfolio.total_amount(@portfolios), fees: Portfolio.fees(@portfolios) }
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