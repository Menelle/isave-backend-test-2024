class CreatePortfolioHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolio_histories do |t|

      t.references :portfolio
      t.monetize :amount
      t.date :captured_at

      t.timestamps
    end
  end
end
