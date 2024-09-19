class PortfolioBackupSerializer < ActiveModel::Serializer
  attributes :label
  attribute :portfolio_histories, key: "history"


  def portfolio_histories
    ActiveModel::Serializer::CollectionSerializer.new(
      object.portfolio_histories.yield_self{ |relation|
        instance_options[:date].present? ? relation.where(captured_at: instance_options[:date]) : relation
      },
      serializer: PortfolioHistorySerializer
    )
  end
end
