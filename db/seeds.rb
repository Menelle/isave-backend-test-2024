# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


customer = Customer.where(email: "thomas@gmail.com").first_or_create(first_name: "Thomas", last_name: "Me", encrypted_password: "password")


[
  { label: "Portefeuille d'actions", type: "Portfolio::Cto", amount: 15000 },
  { label: "PEA - Portefeuille Équilibré", type: "Portfolio::Pea", amount: 30000 },
  { label: "Assurance Vie - Plan d'Épargne", type: "Portfolio::AssuranceVie", amount: 50000 },
  { label: "Livret d'épargne", type: "Portfolio::LivretEpargne", amount: 10000 },
  { label: "Compte courant", type: "Portfolio::CompteCourant", amount: 18000 }
].each do |portfolio|
  customer.portfolios.where(type: portfolio[:type]).first_or_create(label: portfolio[:label], amount: portfolio[:amount])
end


[
  {
    type: "stock",
    isin: "FR0000120172",
    label: "Apple Inc.",
    price: 150.0,
    srri: 6
  },
  {
      type: "bond",
      isin: "FR0000131104",
      label: "Obligation d'État Française",
      price: 200.0,
      srri: 3
  },
  {
      type: "stock",
      isin: "FR0004567890",
      label: "Microsoft Corp.",
      price: 180.0,
      srri: 6
  },
  {
      type: "bond",
      isin: "FR0000456789",
      label: "Obligation d'Entreprise Française",
      price: 220.0,
      srri: 4
  },
  {
      type: "stock",
      isin: "FR0000678910",
      label: "Amazon Inc.",
      price: 160.0,
      srri: 6
  },
  {
      type: "stock",
      isin: "FR0000789012",
      label: "Facebook Inc.",
      price: 190.0,
      srri: 6
  },
  {
      type: "bond",
      isin: "FR0000901234",
      label: "Obligation Municipale Française",
      price: 210.0,
      srri: 4
  },
  {
    type: "stock",
    isin: "FR0012345678",
    label: "iShares Core MSCI World ETF",
    price: 50.0,
    srri: 6
  },
  {
    type: "stock",
    isin: "FR0012345679",
    label: "Vanguard Total Bond Market ETF",
    price: 100.0,
    srri: 5
  },
  {
    type: "euro_fund",
    isin: "FR0098765432",
    label: "Fonds Équilibré Global",
    price: 50.0,
    srri: 1
  },
  {
    type: "bond",
    isin: "FR0098765433",
    label: "Fonds Obligataire",
    price: 100.0,
    srri: 2
  }
].each do |instrument|
  Instrument.where(isin: instrument[:isin]).first_or_create(
    type: instrument[:type],
    label: instrument[:label],
    price: instrument[:price],
    srri: instrument[:srri]
  )
end

[
  { isin: "FR0000120172", amount: 15000 },
  { isin: "FR0000131104", amount: 10000 },
  { isin: "FR0004567890", amount: 12600 },
  { isin: "FR0000456789", amount: 9900 },
  { isin: "FR0000678910", amount: 14400 },
  { isin: "FR0000789012", amount: 11400 },
  { isin: "FR0000901234", amount: 11550 },
].each do |investment|
  instrument = Instrument.find_by(isin: investment[:isin])
  next unless investment
  Investment.where(instrument: instrument, portfolio: Portfolio::Cto.first).first_or_create(amount: investment[:amount])
end

[
  { isin: "FR0012345678", amount: 20000 },
  { isin: "FR0012345679", amount: 10000 },

].each do |investment|
  instrument = Instrument.find_by(isin: investment[:isin])
  next unless investment
  Investment.where(instrument: instrument, portfolio: Portfolio::Pea.first).first_or_create(amount: investment[:amount])
end

[
  { isin: "FR0098765432", amount: 50000 },
  { isin: "FR0098765433", amount: 50000 },

].each do |investment|
  instrument = Instrument.find_by(isin: investment[:isin])
  next unless investment
  Investment.where(instrument: instrument, portfolio: Portfolio::AssuranceVie.first).first_or_create(amount: investment[:amount])
end


file = File.read('./data/level_4/historical_values.json')
data_hash = JSON.parse(file)
data_hash.each{ |portfolio, entries|
  portfolio = customer.portfolios.find_by!(label: portfolio)
  entries.each{ |entry|
    PortfolioHistory.where(portfolio_id: portfolio.id, captured_at: Date.strptime(entry["date"], "%d-%m-%y")).first_or_create(amount: entry["amount"])
  }
}