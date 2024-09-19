# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_19_153156) do
  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
  end

  create_table "instruments", force: :cascade do |t|
    t.string "type"
    t.string "label"
    t.string "isin"
    t.integer "srri"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["isin"], name: "index_instruments_on_isin"
    t.index ["type"], name: "index_instruments_on_type"
  end

  create_table "investments", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "instrument_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instrument_id"], name: "index_investments_on_instrument_id"
    t.index ["portfolio_id", "instrument_id"], name: "index_investments_on_portfolio_id_and_instrument_id", unique: true
    t.index ["portfolio_id"], name: "index_investments_on_portfolio_id"
  end

  create_table "portfolio_histories", force: :cascade do |t|
    t.integer "portfolio_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.date "captured_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_portfolio_histories_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.integer "customer_id"
    t.string "type"
    t.string "label"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_portfolios_on_customer_id"
    t.index ["type"], name: "index_portfolios_on_type"
  end

end
