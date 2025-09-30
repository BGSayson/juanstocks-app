FactoryBot.define do
  factory :wallet do
    id { 1 }
    balance_cents { 20000 }
    balance_currency { 'PHP' }
    user_id { 1 }
  end
end
