class InvestmentSerializer < ActiveModel::Serializer
  attributes :type, :isin, :label, :price, :share, :srri
  attribute :amount_value, key: :amount

  def amount_value
    object.amount.to_d
  end

  def type
    instrument.type
  end

  def isin
    instrument.isin
  end

  def label
    instrument.label
  end

  def price
    instrument.price.to_d
  end

  def share
    # NOTE: had a hard time trying to figure out the relation between portfolio amount and investments amounts in test data.
    # to total (portfolio) amount seems to be different than the sum of all investments amounts.
    # thus the logic may be wrong. It should be (object.amount / object.portfolio.amount).round(2)
    (object.amount / object.portfolio.investments.map(&:amount).sum).round(2)
  end

  def srri
    instrument.srri
  end


  private

  def instrument
    @instrument ||= object.instrument
  end

end
