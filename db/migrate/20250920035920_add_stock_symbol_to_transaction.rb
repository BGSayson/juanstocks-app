class AddStockSymbolToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :stock_symbol, :string
  end
end
