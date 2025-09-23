class RemoveUsdExchangeRateFromWallets < ActiveRecord::Migration[8.0]
  def change
    remove_column :wallets, :usd_exchange_rate
  end
end
