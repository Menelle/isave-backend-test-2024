module PortFolioManager do

  class Withdrawal do

    class WithdrawalError < StandardError; end
    Result = Struct.new(:success?, :errors)

    attr_reader :portfolio, :investment, :amount

    def initialize(portfolio:, investment:, amount:)
      @portfolio = portfolio
      @investment = investment
      @amount = amount
    end

    def call
      raise WithdrawalError, "Insufficient funds" if insufficient_funds?

      # prevent customer to withdraw more than available
      available_withdrawal_amount = [investment.amount, amount].min
      ActiveRecord::Base.transaction do
        portfolio.update!(amount: portfolio.amount - available_withdrawal_amount)
        investment.update!(amount: available_withdrawal_amount)
      end
    rescue => e
      Result.new(success?: false, errors: e.message)
    else
      Result.new(success?: true)
    end

    private

    def insufficient_funds?
      investment.amount < amount
    end

  end

end
