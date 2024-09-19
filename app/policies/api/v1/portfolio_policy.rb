class Api::V1::PortfolioPolicy
  attr_reader :customer, :portfolio

  def initialize(customer, portfolio)
    @customer = customer
    @portfolio = portfolio
  end

  def deposit?
    portfolio.cto? || portfolio.pea?
  end
  alias_method :withdrawal?, :deposit?
  alias_method :transfer?, :deposit?

end