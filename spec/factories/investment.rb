FactoryBot.define do
  factory :investment do
    id { 1 }
    wallet_id { 1 }
    total_share_amount { 100 }
    buying_price_cents { 20000 }
    buying_price_currency { 'USD' }
    stock_id { 1 }
  end
end
