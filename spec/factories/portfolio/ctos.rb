FactoryBot.define do
  factory :portfolio_cto, class: "Portfolio::Cto" do
    type { "Portfolio::Cto" }
    label { "Portefeuille d'actions" }
    amount { Money.new(Faker::Commerce.price(range: 10000.0..100000.0), "EUR") }

    trait :with_investments do
      after(:create) do |portfolio|
        stock = create(:stock)
        bond = create(:bond)
        create(:investment, portfolio: portfolio, instrument: stock)
        create(:investment, portfolio: portfolio, instrument: bond)
      end
    end
  end
end
