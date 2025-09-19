class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, {buy: 0, sell: 1, withdraw: 2, deposit: 3}

  after_save :update_wallet

  def buy(buy_price) 
    self.wallet.withdraw(buy_price)
  end

  def sell(sell_price) 
    self.wallet.deposit(sell_price)
  end

  private
  def update_wallet
    new_balance = 0

    case self.transaction_type
    when "buy"
      if self.wallet.balance_is_negative
        # self.wallet.investment.add(params[:share_amount, :price])
        new_balance = self.wallet.withdraw(self.price)
      else
        raise "CATCH THIS TEST PLEASE"
      end
    when "sell"
      # self.wallet.investment.remove(params[:share_amount, :price])
      new_balance = self.wallet.deposit(self.price)
    when "withdraw"
      if self.wallet.balance_is_negative
        new_balance = self.wallet.withdraw(self.price)
      else
        raise "CATCH THIS TEST PLEASE"
      end
    when "deposit"
      new_balance = self.wallet.deposit(self.price)
    end

    self.wallet.update!(
      balance: new_balance
    )
  end
end
