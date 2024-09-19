FactoryBot.define do
  factory :portfolio_pea, class: "Portfolio::Pea" do
    type { "Portfolio::Pea" }
    label { "Portefeuille Équilibré" }
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