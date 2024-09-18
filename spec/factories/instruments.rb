FactoryBot.define do
  factory :instrument do
    isin { Faker::Internet.uuid }
    price { Faker::Commerce.price(range: 1.0..100000.0) }
    srri { rand(7) }
    label{ Faker::Company.name }

    factory :stock do
      type { "stock" }
    end

    factory :bond do
      type { "stock" }
    end

    factory :euro_fund do
      type { "euro_fund" }
    end

  end
end
