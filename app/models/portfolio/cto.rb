class Portfolio::Cto < Portfolio
  has_many :investments, foreign_key: :portfolio_id
  has_many :instruments, through: :investments

  def type_value
    "CTO"
  end

  def label
    "Portefeuille d'actions"
  end
end
