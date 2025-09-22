class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, {buy: 0, sell: 1, withdraw: 2, deposit: 3}
  
  after_create :update_wallet

  def buy(share_amount, stock_symbol)
    # add investment
    buy_price = self.wallet.add_investment(share_amount, stock_symbol)
    new_balance = self.wallet.withdraw(buy_price)
    return new_balance
  end

  def sell(share_amount, stock_symbol)
    # remove investment 
    sell_price = self.wallet.remove_investment(share_amount, stock_symbol)
    new_balance = self.wallet.deposit(sell_price)
    return new_balance
  end

  private
  def update_wallet
    new_balance = 0

    case self.transaction_type
    when "buy"
      new_balance = self.buy(self.share_amount, self.stock_symbol)
      if self.wallet.balance_is_negative || new_balance < 0
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "sell"
      new_balance = self.sell(self.investment_id, self.share_amount, self.stock_symbol)
    when "withdraw"
      new_balance = self.wallet.withdraw(self.price)
      if self.wallet.balance_is_negative || new_balance < 0
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "deposit"
      if self.price > 0
        new_balance = self.wallet.deposit(self.price)
      else
        raise WalletError, "Cannot deposit negative amounts"
      end
    end

    self.wallet.update!(
      balance: new_balance
    )
  end
end
