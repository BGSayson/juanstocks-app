class ChangePriceCurrencyFromTransaction < ActiveRecord::Migration[8.0]
  def change
    change_column_default :transactions, :price_currency, from: "USD", to: "PHP"
  end
end
