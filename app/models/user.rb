class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :first_name, presence: true
  validates :last_name, presence: true
  
  enum :user_status, {buyer_only: 0, buyer_broker: 1, deactivated: 2}
  enum :user_role, {buyer: 0, admin: 1, broker: 2 }

  has_one :wallet

  # get an api key from this site https://app.exchangerate-api.com/dashboard

  after_save :create_wallet

  private
  def create_wallet
    opexr_fetch_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{ENV["OPEXRATES_API_KEY"]}/pair/USD/PHP")
    if opexr_fetch_response['result'] == "success"
      opexr_usd_php_exchange_rate = opexr_fetch_response['conversion_rate']
      Wallet.create!(
        user: self,
        balance: 0,
        usd_exchange_rate: opexr_usd_php_exchange_rate
      )
    else raise StandardError, "Unable to fetch"
    end
  end
end
