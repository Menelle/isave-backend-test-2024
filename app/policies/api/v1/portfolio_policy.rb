class PortfolioPolicy
  attr_reader :customer, :portfolio

  def initialize(customer, portfolio)
    @customer = customer
    @portfolio = portfolio
  end

  def create?
    portfolio.cto? || portfolio.pea?
  end

end