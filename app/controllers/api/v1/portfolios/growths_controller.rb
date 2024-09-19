class Api::V1::Portfolios::GrowthsController < Api::V1::ApplicationController

  before_action :set_portfolios

  # I want to see the returns (percentage growth) of my portfolios globally and at a given date in the past
  def index
    render json: ActiveModel::Serializer::CollectionSerializer.new(
      @portfolios,
      serializer: PortfolioGrowthSerializer,
      date: params[:date]
    ).as_json
  end

  private

  def set_portfolios
    @portfolios ||=
      current_customer.portfolios.investing.includes(investments: :instrument).yield_self{ |relation|
        params[:ids].present? ? relation.where(id: params[:ids].split(",")) : relation
      }
  end

end