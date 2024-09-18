class Portfolio < ApplicationRecord
  INSTRUMENT_TYPES = ["Portfolio::Cto", "Portfolio::Pea", "Portfolio::AssuranceVie", "Portfolio::LivretEpargne", "Portfolio::CompteCourant"]

  monetize :amount_cents

  belongs_to :customer

  validates :type, inclusion: { in: INSTRUMENT_TYPES }
end
