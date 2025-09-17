class CreateInvestments < ActiveRecord::Migration[8.0]
  def change
    create_table :investments do |t|
      t.references :wallet, null: false, foreign_key: true
      t.integer :total_share_amount, null: false
      t.monetize :buying_price, null: false
      t.timestamps
    end
  end
end
