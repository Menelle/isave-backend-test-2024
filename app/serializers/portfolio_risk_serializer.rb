class PortfolioRiskSerializer < ActiveModel::Serializer
  attributes :label
  attribute :amount_value, key: :amount
  attribute :risk_level, key: :risk

  def investments
    object.investments
  end

  def amount_value
    object.amount.to_d
  end

end
