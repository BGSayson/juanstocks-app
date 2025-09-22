class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.string :currency
      t.string :description
      t.string :display_symbol
      t.string :symbol

      t.monetize :current_price
      t.float :change
      t.float :percent_change
      t.monetize :high_price_of_the_day
      t.monetize :low_price_of_the_day
      t.monetize :open_price_of_the_day
      t.monetize :previous_close_price

      t.timestamps
    end
  end
end
