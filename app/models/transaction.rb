class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, {buy: 0, sell: 1, withdraw: 2, deposit: 3}
  
  after_create :update_wallet

  def buy(share_amount, stock_symbol)
    # add investment
    id_price_array = self.wallet.add_investment(share_amount, stock_symbol)
    buy_price = id_price_array[1]
    new_balance = self.wallet.withdraw(buy_price)
    return id_price_array << new_balance
  end

  def sell(investment_id, share_amount, stock_symbol)
    # remove investment 
    sell_price_destroyed_array = self.wallet.remove_investment(investment_id, share_amount, stock_symbol)
    sell_price = sell_price_destroyed_array[0]
    new_balance = self.wallet.deposit(sell_price)
    return sell_price_destroyed_array << new_balance
  end

  private
  def update_wallet
    new_balance = 0

    case self.transaction_type
    when "buy"
      id_price_array = self.buy(self.share_amount, self.stock_symbol)
      Transaction.find(self.id).update!(price: id_price_array[1].exchange_to('PHP'), investment_id:id_price_array[0])
      new_balance = id_price_array[2]
      if self.wallet.balance_is_negative || new_balance < 0
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "sell"
      price_balance_array = self.sell(self.investment_id, self.share_amount, self.stock_symbol)
      new_balance = price_balance_array[2]
      
      target_investment = Investment.find(self.investment_id)
      stock_symbol = Stock.find(target_investment.stock_id).symbol
      Transaction.find(self.id).update!(price: price_balance_array[0].exchange_to('PHP'), stock_symbol: stock_symbol)
      if(price_balance_array[1] == true)
        Investment.destroy(target_investment.id)
      end
    when "withdraw"
      new_balance = self.wallet.withdraw(self.price)
      Transaction.find(self.id).update!(stock_symbol: nil, investment_id:nil)
      if self.wallet.balance_is_negative || new_balance < 0
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "deposit"
      if self.price > 0
        new_balance = self.wallet.deposit(self.price)
        Transaction.find(self.id).update!(stock_symbol: nil, investment_id:nil)
      else
        raise WalletError, "Cannot deposit negative amounts"
      end
    end

    self.wallet.update!(
      balance: new_balance
    )
  end
end
