class Portfolio::AssuranceVie < Portfolio

  has_many :instruments, through: :investments

  def type
    "Assurance Vie"
  end

  def label
    "Assurance Vie - Plan d'Épargne"
  end
end
