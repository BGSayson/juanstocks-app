class AddStockRefToInvestments < ActiveRecord::Migration[8.0]
  def change
    add_reference :investments, :stock, foreign_key: true
  end
end
