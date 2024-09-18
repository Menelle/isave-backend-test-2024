# WARN: may not be part of the portfolio - should we attach it directly to/be part of the customer object?

class Portfolio::CompteCourant < Portfolio

  def type_value
    "Compte dépôt"
  end

  def label
    "Compte courant"
  end
end
