FactoryBot.define do
  factory :user do
    id { 1 }
    first_name { 'John' }
    last_name  { 'Doe' }
    email  { 'john@doe.com' }
    password { 'password123' }
    user_role { :admin }
    user_status { :buyer_only }
    confirmed_at { Time.now }
  end
end
