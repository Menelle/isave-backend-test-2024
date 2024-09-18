class CreateInstruments < ActiveRecord::Migration[7.1]
  def change
    create_table :instruments do |t|
      t.string :type
      t.string :label
      t.string :isin
      t.integer :srri
      t.monetize :price

      t.timestamps
    end

    add_index :instruments, :isin
    add_index :instruments, :type
  end
end
