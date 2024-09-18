class Investment < ApplicationRecord
  monetize :amount_cents

  belongs_to :portfolio
  belongs_to :instrument
end
