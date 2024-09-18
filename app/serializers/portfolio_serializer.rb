class PortfolioSerializer < ActiveModel::Serializer
  attributes :label
  attribute :amount_value, key: :amount
  attribute :type_value, key: :type
  has_many :investments, if: :with_investments?, key: "lines"

  def amount_value
    object.amount.to_d
  end

  def with_investments?
    object.respond_to?(:investments) && object.investments.size.positive?
  end

end
