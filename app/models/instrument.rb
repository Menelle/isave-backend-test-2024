class Instrument < ApplicationRecord
self.inheritance_column = "NotType"

  TYPES = %w(stock bond euro_fund)

  monetize :price_cents

  has_many :portfolios, through: :investments

  validates :isin, :label, :srri, presence: true
  validates :type, inclusion: { in: TYPES }
  validates :price, numericality: { greater_than: 0 }
end
