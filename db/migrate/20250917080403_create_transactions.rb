class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.integer :transaction_type, default: 0
      t.integer :share_amount
      t.monetize :price, null: false
      t.timestamps
    end
  end
end
