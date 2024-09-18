module PortFolioManager do

  class Transfert do

    class TransfertError < StandardError; end
    # Result

    attr_reader :portfolio, :investment_from, :investment_to, :amount

    def initialize(portfolio:, investment_from:, investment_to:, amount:)
      @portfolio = portfolio
      @investment_from = investment_from
      @investment_to = investment_to
      @amount = amount
    end

    def call
      raise TransfertError, "Insufficient funds" if insufficient_funds?

      # prevent customer to transfert more than available
      available_transfert_amount = [investment_from.amount, amount].min
      ActiveRecord::Base.transaction do
        portfolio.update!(amount: portfolio.amount - available_withdrawal_amount)
        investment_from.update!(amount: investment_from.amount - available_transfert_amount)
        investment_to.update!(amount: investment_to.amount + available_transfert_amount)
      end
    rescue => e
      Result.new(success?: false, errors: e.message)
    else
      Result.new(success?: true)
    end

    private

    def insufficient_funds?
      investment_from.amount < amount
    end

  end

end
