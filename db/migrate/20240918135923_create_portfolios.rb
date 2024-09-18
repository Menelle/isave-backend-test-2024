class CreatePortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.references :customer
      t.string :type
      t.string :label
      t.monetize :amount

      t.timestamps
    end

    add_index :portfolios, :type
  end
end
