class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, {buy: 0, sell: 1, withdraw: 2, deposit: 3}

  after_save :update_wallet

  def buy(buy_price)
    # add investment
    new_balance = self.wallet.withdraw(buy_price)
    return new_balance
  end

  def sell(sell_price)
    # remove investment 
    new_balance = self.wallet.deposit(sell_price)
    return new_balance
  end

  private
  def update_wallet
    new_balance = 0

    case self.transaction_type
    when "buy"
      if self.wallet.balance_is_negative
        new_balance = self.buy(self.share_amount, self.stock, self.price)
      else
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "sell"
      new_balance = self.sell(self.share_amount, self.stock, self.price)
    when "withdraw"
      if self.wallet.balance_is_negative
        new_balance = self.wallet.withdraw(self.price)
      else
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "deposit"
      new_balance = self.wallet.deposit(self.price)
    end

    self.wallet.update!(
      balance: new_balance
    )
  end
end
