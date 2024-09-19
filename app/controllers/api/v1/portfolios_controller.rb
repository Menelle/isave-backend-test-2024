class Api::V1::PortfoliosController < Api::V1::ApplicationController

  before_action :set_portfolio, except: %i(index risk break)

  def index
    # NOTE: authorization for the customer here
    # TODO: improve the associations definition to eager log here
    portfolios = current_customer.portfolios
    render json: portfolios, each_serializer: PortfolioSerializer, adapter: :json, root: "contracts"
  end

  # NOTE: I can deposit money into an existing investment
  def deposit
    authorize @portfolio, policy_class: Api::V1::PortfolioPolicy
    investment = @portfolio.investments.find(deposit_params[:investment_id])

    deposit =
      PortfolioManager::Deposit.new(
        portfolio: @portfolio,
        investment:,
        amount: deposit_params[:amount]
      ).call

    if deposit.success?
      render json: { success: true }, status: 201
    else
      render json: {success: false, errors: deposit.errors }, status: 403
    end
  end

  # NOTE: I can transfer money from one of my investments to another
  def transfer
    authorize @portfolio, policy_class: Api::V1::PortfolioPolicy
    investment_from = @portfolio.investments.find(transfer_params[:investment_from_id])
    investment_to = @portfolio.investments.find(transfer_params[:investment_to_id])
    transfer =
      PortfolioManager::Transfer.new(
        portfolio: @portfolio,
        investment_from:,
        investment_to:,
        amount: transfer_params[:amount]
      ).call

    if transfer.success?
      render json: { success: true }, status: 201
    else
      render json: { success: false, errors: transfer.errors }, status: 403
    end
  end

  # NOTE: I can withdraw money from an existing investment
  def withdrawal
    authorize @portfolio, policy_class: Api::V1::PortfolioPolicy

    investment = @portfolio.investments.find(withdrawal_params[:investment_id])
    withdrawal =
      ::PortfolioManager::Withdrawal.new(
        portfolio: @portfolio,
        investment:,
        amount: withdrawal_params[:amount]
      ).call

    if withdrawal.success?
      render json: { success: true }, status: 201
    else
      render json: { success: false, errors: withdrawal.errors }, status: 403
    end
  end

  private

  def set_portfolio
    @portfolio ||= current_customer.portfolios.find(params[:id])
  end

  def deposit_params
    params.permit(:id, :investment_id, :amount)
  end

  def withdrawal_params
    params.permit(:id, :investment_id, :amount)
  end

  def transfer_params
    params.permit(:id, :investment_from_id, :investment_to_id, :amount)
  end

end
