class ChangeBuyingPriceCurrencyFromInvestments < ActiveRecord::Migration[8.0]
  def change
    change_column_default :investments, :buying_price_currency, from: "USD", to: "PHP"
  end
end
