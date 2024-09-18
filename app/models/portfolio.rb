class Portfolio < ApplicationRecord
  TYPE_CTO = "Portfolio::Cto".freeze
  TYPE_PEA = "Portfolio::Pea".freeze
  TYPES = [TYPE_CTO, TYPE_PEA, "Portfolio::AssuranceVie", "Portfolio::LivretEpargne", "Portfolio::CompteCourant"]


  monetize :amount_cents

  belongs_to :customer

  validates :type, inclusion: { in: TYPES }

  def cto?
    type == TYPE_CTO
  end

  def pea?
    type == TYPE_PEA
  end
end
