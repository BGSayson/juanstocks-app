FactoryBot.define do
  factory :stock do
    id { 1 }
    currency { "USD" }
    description { "NVIDIA Corp" }
    display_symbol { "https://static2.finnhub.io/file/publicdatany/finnhubimage/stock_logo/NVDA.png" }
    symbol { "NVDA" }
    current_price_cents { 17667 }
    current_price_currency { "USD" }
    change { 0.43 }
    percent_change { 0.244 }
    high_price_of_the_day_cents { 17808 }
    high_price_of_the_day_currency { "USD" }
    low_price_of_the_day_cents { 17518 }
    low_price_of_the_day_currency { "USD" }
  end
end
