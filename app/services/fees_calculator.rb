class FeesCalculator

  attr_reader :amount, :steps

  def initialize(amount:, steps: Portfolio::FEE_STEPS)
    @amount = amount
    @steps = steps
  end

  def call
    fees = {}
    steps.inject(amount) do |mem, step|
      current_amount = [0, mem - step[1]].max
      fees[step[0].to_s.parameterize(separator: "_")] = current_amount * step[0]
      mem - current_amount
    end

    fees
  end

end