class Investment < ApplicationRecord
  belongs_to :wallet
  monetize :buying_price_cents

  validates :total_share_amount, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def add(share_amount) 
    self.wallet.withdraw(buy_price)
  end

  def sell(sell_price) 
    self.wallet.deposit(sell_price)
  end
end
