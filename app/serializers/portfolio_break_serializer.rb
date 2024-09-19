class PortfolioBreakSerializer < ActiveModel::Serializer
  attributes :label
  attribute :investments_by_types, key: :breakdown

  def investments_by_types
    object.investments_by_type.transform_values{ |v| Money.new(v).to_d }
  end

  def amount_value
    object.amount.to_d
  end

end