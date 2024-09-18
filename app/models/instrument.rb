class Instrument < ApplicationRecord
  INSTRUMENT_TYPES = %w(stock bond euro_fund)

  monetize :price_cents

  has_many :portfolios, through: :investments

  validates :type, inclusion: { in: INSTRUMENT_TYPES }
end
