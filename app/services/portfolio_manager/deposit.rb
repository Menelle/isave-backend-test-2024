module PortFolioManager do

  class Deposit do

    attr_reader :portfolio, :investment, :amount

    def initialize(portfolio:, investment:, amount:)
      @portfolio = portfolio
      @investment = investment
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        portfolio.update!(amount: portfolio.amount + amount)
        investment.update!(amount: amount)
      end
    rescue => e
      Result.new(success?: false, errors: e.message)
    else
      Result.new(success?: true)
    end

  end

end
