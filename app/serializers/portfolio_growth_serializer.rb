class PortfolioGrowthSerializer < ActiveModel::Serializer

  attributes :label, :return, :current_date

  def current_date
    if history?
      history.captured_at.strftime("%d-%m-%Y")
    else
      Date.today.strftime("%d-%m-%Y")
    end
  end

  def return
    history
    value_initial = object.portfolio_histories.order(captured_at: :asc).first.amount.to_d
    value_current = (history? ? history : object).amount.to_d

    "#{(value_current / value_initial - 1) * 100}%"
  end

  private

  def history?
    instance_options[:date].present? && history
  end

  def history
    @history ||= object.portfolio_histories.find_by(captured_at: instance_options[:date])
  end

end
