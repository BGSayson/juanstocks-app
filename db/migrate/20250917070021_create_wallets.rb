class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets do |t|
      t.monetize :balance, null: false
      t.integer :user_id
      t.timestamps
    end
  end
end
