FactoryBot.define do
  factory :portfolio_cto, class: 'Portfolio::Cto' do
    type { "Portfolio::Cto" }
    label { "Portefeuille d'actions" }
    amount { Faker::Commerce.price(range: 10000.0..100000.0) }

    trait :with_investments do
      after(:create) do |portfolio|
        instrument = create(:instrument)
        instrument_2 = create(:instrument)
        create(:investment, portfolio: portfolio, instrument: instrument)
        create(:investment, portfolio: portfolio, instrument: instrument_2)
      end
    end
  end
end
