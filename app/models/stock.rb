class Stock < ApplicationRecord
  monetize :current_price_cents
  monetize :high_price_of_the_day_cents
  monetize :low_price_of_the_day_cents
  monetize :open_price_of_the_day_cents
  monetize :previous_close_price_cents

  scope :top_stocks, -> { order(percent_change: :desc) }


  # txs = current_user.wallet.investments.first(5)
  # Stock.find(stock.stock_id).percent_change
end
