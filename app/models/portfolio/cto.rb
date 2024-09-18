class Portfolio::Cto < Portfolio

  has_many :instruments, through: :investments

  def type
    "CTO"
  end

  def label
    "Portefeuille d'actions"
  end
end
