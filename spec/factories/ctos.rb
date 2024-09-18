FactoryBot.define do
  factory :cto do
    type { "Cto" }
    label { "Portefeuille d'actions" }
    amount { Faker::Commerce.price(range: 10000.0..100000.0) }

    trait :with_investment do
      after(:create) do |portfolio|
        instrument = create(:instrument)
        create(:investment, portfolio: portfolio, instrument: instrument)
      end
    end
  end
end