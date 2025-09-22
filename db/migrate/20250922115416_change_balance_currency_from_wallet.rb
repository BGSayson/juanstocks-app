class ChangeBalanceCurrencyFromWallet < ActiveRecord::Migration[8.0]
  def change
    change_column_default :wallets, :balance_currency, from: "USD", to: "PHP"
  end
end
