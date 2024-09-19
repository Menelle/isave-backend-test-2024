module PortfolioManager
  class Transfer

    class TransferError < StandardError; end
    Result = Struct.new(:success?, :errors)

    attr_reader :portfolio, :investment_from, :investment_to, :amount

    def initialize(portfolio:, investment_from:, investment_to:, amount:)
      @portfolio = portfolio
      @investment_from = investment_from
      @investment_to = investment_to
      @amount = amount
    end

    def call
      raise TransferError, "Insufficient funds, available: #{available_transfer_amount.format}" if insufficient_funds?

      # prevent customer to transfer more than available
      ActiveRecord::Base.transaction do
        investment_from.update!(amount: investment_from.amount - amount_monetized)
        investment_to.update!(amount: investment_to.amount + amount_monetized)
      end
    rescue => e
      Result.new(success?: false, errors: e.message)
    else
      Result.new(success?: true)
    end

    private

    def amount_monetized
      Money.new(amount.to_f * 100)
    end

    def insufficient_funds?
      investment_from.amount < amount_monetized
    end

    def available_transfer_amount
      [investment_from.amount, amount_monetized].min
    end

  end

end
