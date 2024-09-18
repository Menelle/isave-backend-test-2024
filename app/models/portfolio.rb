class Portfolio < ApplicationRecord
  INSTRUMENT_TYPES = ["CTO", "PEA", "Assurance Vie", "Livret A", "Compte dépôt"]

  monetize :amount_cents

  belongs_to :customer

  validates :type, inclusion: { in: INSTRUMENT_TYPES }
end
