class Api::V1::PortfoliosController < Api::V1::ApplicationController

  before_action :set_portfolio, except: %i(index)

  def index
    # NOTE: authorization for the customer here
    # TODO: improve the associations logic to eager log here
    portfolios = current_customer.portfolios
    render json: portfolios, each_serializer: PortfolioSerializer, adapter: :json, root: "contracts"
  end

  # NOTE: I can deposit money into an existing investment
  def create
    authorize @portfolio
    investment = @portfolio.investments.find(deposit_params[:investment_id])
    deposit =
      PortFolioManager::Deposit.new.call(
        portfolio: @portfolio,
        investment: investment,
        amount: deposit_params[:amount]
      )

    if deposit.success?
      render json: {}, status: 201
    else
      render json: deposit.errors, status: 500
    end
  end

  # NOTE: I can transfer money from one of my investments to another.
  def update
    authorize @portfolio
    investment_from = @portfolio.investments.find(transfert_params[:investment_from_id])
    investment_to = @portfolio.investments.find(transfert_params[:investment_to_id])
    transfert =
      PortFolioManager::Transfert.new.call(
        portfolio: @portfolio,
        investment_from: investment_from,
        investment_to: investment_to,
        amount: transfert_params[:amount]
      )

    if transfert.success?
      render json: {}, status: 201
    else
      render json: transfert.errors, status: 500
    end
  end

  # NOTE: I can withdraw money from an existing investment.
  def destroy
    authorize @portfolio
    investment = @portfolio.investments.find(deposit_params[:investment_id])
    withdrawal =
      PortFolioManager::Withdrawal.new.call(
        portfolio: @portfolio,
        investment: investment,
        amount: withdrawal_params[:amount]
      )

    if withdrawal.success?
      render json: {}, status: 201
    else
      render json: withdrawal.errors, status: 500
    end
  end


  private

  def set_portfolio
    @portfolio ||= current_customer.porfolios.find(params[:id])
  end

  def deposit_params
    params.require(:portfolio).permit(:id, :investment_id, :amount)
  end

  def transfert_params
    params.require(:portfolio).permit(:id, :investment_from_id, :investment_to_id, :amount)
  end

# { "contracts": ActiveModel::Serializer::CollectionSerializer.new(
#   portfolios,
#   serializer: PortfolioSerializer,
# ).as_json }

end
