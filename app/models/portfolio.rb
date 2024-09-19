class Portfolio < ApplicationRecord
  TYPE_CTO = "Portfolio::Cto".freeze
  TYPE_PEA = "Portfolio::Pea".freeze
  TYPE_ASSURANCE_VIE = "Portfolio::AssuranceVie".freeze
  TYPES_INVESTING = [TYPE_CTO, TYPE_PEA, TYPE_ASSURANCE_VIE]
  TYPES = [TYPE_CTO, TYPE_PEA, TYPE_ASSURANCE_VIE, "Portfolio::LivretEpargne", "Portfolio::CompteCourant"]

  scope :investing, -> { where(type: TYPES_INVESTING) }

  monetize :amount_cents

  belongs_to :customer

  validates :type, inclusion: { in: TYPES }

  def cto?
    type == TYPE_CTO
  end

  def pea?
    type == TYPE_PEA
  end

  def total_investments_cents
    return 0 unless respond_to?(:investments)
    investments.pluck(:amount_cents).sum
  end

  def risk_level
    (investments.inject{ |_, investment| investment.amount.to_d / amount.to_d * investment.instrument.srri }).round(2)
  end

  def investments_by_type
    investments.joins(:instrument).group("instruments.type").sum("investments.amount_cents")
  end

  class << self
    def total_risk_level(portfolios)
      (portfolios.map{ |portfolio| portfolio.risk_level }.sum / portfolios.size).round(2)
    end

    def total_amount(portfolios)
      (portfolios.map{ |portfolio| portfolio.amount.to_d }.sum).round(2)
    end

    def investments_cents_by_types(portfolios)
      Investment.where(portfolio: portfolios).joins(:instrument).group("instruments.type").sum("investments.amount_cents")
    end
  end

end
