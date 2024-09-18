class Portfolio::AssuranceVie < Portfolio
  has_many :investments, foreign_key: :portfolio_id
  has_many :instruments, through: :investments

  def type_value
    "Assurance Vie"
  end

  def label
    "Assurance Vie - Plan d'Épargne"
  end
end
