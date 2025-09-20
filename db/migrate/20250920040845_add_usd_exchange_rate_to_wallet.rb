class AddUsdExchangeRateToWallet < ActiveRecord::Migration[8.0]
  def change
    add_column :wallets, :usd_exchange_rate, :float
  end
end
