module PortfolioManager
  class Withdrawal

    class WithdrawalError < StandardError; end
    Result = Struct.new(:success?, :errors)

    attr_reader :portfolio, :investment, :amount

    def initialize(portfolio:, investment:, amount:)
      @portfolio = portfolio
      @investment = investment
      @amount = amount
    end

    def call
      # prevent customer to withdraw more than available
      raise WithdrawalError, "Insufficient funds, available: #{available_withdrawal_amount.format}" if insufficient_funds?
      ActiveRecord::Base.transaction do
        portfolio.update!(amount: portfolio.amount - amount_monetized)
        investment.update!(amount: investment.amount - amount_monetized)
      end
    rescue => e
      Result.new(success?: false, errors: e.message)
    else
      Result.new(success?: true)
    end

    private


    def amount_monetized
      Money.new(amount.to_f * 100, Money.default_currency.iso_code)
    end

    def insufficient_funds?
      investment.amount < amount_monetized
    end

    def available_withdrawal_amount
      [investment.amount, amount_monetized].min
    end

  end
end
