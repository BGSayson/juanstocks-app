class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, {buy: 0, sell: 1, withdraw: 2, deposit: 3}

  def buy(buy_price) 
    self.wallet.withdraw(buy_price)
  end

  def sell(sell_price) 
    self.wallet.deposit(sell_price)
  end
end
