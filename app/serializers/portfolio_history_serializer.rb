class PortfolioHistorySerializer < ActiveModel::Serializer
  attribute :amount_value, key: :amount
  attribute :date_value, key: :date

  def amount_value
    object.amount.to_d
  end

  def date_value
    object.captured_at.strftime("%d-%m-%y")
  end
end
