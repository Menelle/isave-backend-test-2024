class Portfolio::Pea < Portfolio

  has_many :instruments, through: :investments

  def type
    "PEA"
  end

  def label
    "PEA - Portefeuille Équilibré"
  end
end
