class Stock < ApplicationRecord
  monetize :current_price_cents
  monetize :high_price_of_the_day_cents
  monetize :low_price_of_the_day_cents
  monetize :open_price_of_the_day_cents
  monetize :previous_close_price_cents
end
