class Api::V1::PortfoliosController < Api::V1::ApplicationController

  def index
    # NOTE: authorization for the customer here
    # TODO: improve the associations logic to eager log here
    portfolios = current_customer.portfolios
    render json: portfolios, each_serializer: PortfolioSerializer, adapter: :json, root: "contracts"
  end

end

# { "contracts": ActiveModel::Serializer::CollectionSerializer.new(
#   portfolios,
#   serializer: PortfolioSerializer,
# ).as_json }