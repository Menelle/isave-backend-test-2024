class CreateInvestments < ActiveRecord::Migration[7.1]
  def change
    create_table :investments do |t|
      t.references :portfolio
      t.references :instrument
      t.monetize :amount

      t.timestamps
    end

    # NOTE: A eligible portfolio can only invest once in a given instrument.
    add_index :investments, [:portfolio_id, :instrument_id], unique: true
  end
end
