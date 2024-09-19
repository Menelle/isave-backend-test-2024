class Api::V1::Portfolios::BreaksController < Api::V1::ApplicationController

  before_action :set_portfolios, only: %i(index)

  # NOTE: I want to see the breakdown of my Portfolio by investment type (stock, bond, etc.) to understand how my money is invested.
  # NOTE: I want to see the overall breakdown of all my investments by type, to understand where all my money is spread across all my portfolios
  def index
    result =
    if params[:id].present?
      ActiveModel::Serializer::CollectionSerializer.new(
        @portfolios,
        serializer: PortfolioBreakSerializer,
      )
    else
      { breakdown: Portfolio.investments_cents_by_types(@portfolios) }
    end
      render json: result.as_json
  end

  private

  def set_portfolios
    @portfolios ||=
      current_customer.portfolios.investing.includes(investments: :instrument).yield_self{ |relation|
        params[:id].present? ? relation.where(id: params[:id]) : relation
      }
  end

end
