class Portfolio::Pea < Portfolio
  has_many :investments, foreign_key: :portfolio_id
  has_many :instruments, through: :investments

  def type_value
    "PEA"
  end

  def label
    "PEA - Portefeuille Équilibré"
  end
end
