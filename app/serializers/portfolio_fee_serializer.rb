class PortfolioFeeSerializer < ActiveModel::Serializer
  attributes :label
  attribute :amount_value, key: :amount
  attributes :fees

  def investments_by_types
    object.investments_by_type.transform_values{ |v| Money.new(v).to_d }
  end

  def amount_value
    object.amount.to_d
  end

end
