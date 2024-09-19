class Api::V1::Portfolios::HistoriesController < Api::V1::ApplicationController

  before_action :set_portfolios

  # NOTE: I want to see the historical valuation of each of my portfolios
  def index
    render json:
      ActiveModel::Serializer::CollectionSerializer.new(
        @portfolios,
        serializer: PortfolioBackupSerializer,
        date: params[:date]
      ).as_json
  end

  private

  def set_portfolios
    @portfolios ||=
      current_customer.portfolios.joins(:portfolio_histories).yield_self{ |relation|
        params[:ids].present? ? relation.where(id: params[:ids].split(",")) : relation
      }.yield_self{ |relation|
        if params[:date].present?
          relation.where("portfolio_histories.captured_at = ?", params[:date])
        else
          relation
        end
      }
  end

end