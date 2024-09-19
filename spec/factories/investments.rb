FactoryBot.define do
  factory :investment do
    amount { Money.new(5000, "EUR") }
  end
end
