class PortfolioHistory < ApplicationRecord
  monetize :amount_cents

  belongs_to :portfolio


  class << self
    def total_amount(portfolios)
      (portfolios.map{ |portfolio| portfolio.amount.to_d }.sum).round(2)
    end

    def fees(histories)
      FeesCalculator.new(amount: self.total_amount(histories)).call
    end
  end
end
