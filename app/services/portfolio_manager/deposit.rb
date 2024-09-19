module PortfolioManager
  class Deposit

    Result = Struct.new(:success?, :errors)

    attr_reader :portfolio, :investment, :amount

    def initialize(portfolio:, investment:, amount:)
      @portfolio = portfolio
      @investment = investment
      @amount = amount
    end

    def call
      ActiveRecord::Base.transaction do
        portfolio.update!(amount: portfolio.amount + amount_monetized)
        investment.update!(amount: investment.amount + amount_monetized)
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


  end

end
