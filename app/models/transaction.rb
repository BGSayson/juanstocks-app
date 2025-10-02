class Transaction < ApplicationRecord
  belongs_to :wallet
  monetize :price_cents

  enum :transaction_type, { buy: 0, sell: 1, withdraw: 2, deposit: 3 }

  after_create :update_wallet

  scope :recent_txs, -> { order(created_at: :desc) }

  def buy(share_amount, stock_symbol)
    # call add_investment of wallet and get the array [investment.id, price]
    id_price_array = self.wallet.add_investment(share_amount, stock_symbol)
    buy_price = id_price_array[1]
    new_balance = self.wallet.subtract(buy_price)
    # return [investment.id, price, new_balance]
    # if new_balance isn't included in the return array, update_wallet will not know user's new balance after the buy transaction
    id_price_array << new_balance
  end

  def sell(investment_id, share_amount, stock_symbol)
    # call remove_investment of wallet and get the array [price, delete_this_investment]
    sell_price_destroyed_array = self.wallet.remove_investment(investment_id, share_amount, stock_symbol)
    sell_price = sell_price_destroyed_array[0]
    new_balance = self.wallet.add(sell_price)
    # return [price, delete_this_investment, new_balance]
    # if new_balance isn't included in the return array, update_wallet will not know user's new balance after the sell transaction
    sell_price_destroyed_array << new_balance
  end

  private
  # PLEASE DON'T TOUCH THIS, THIS IS MY CHILD - KELCIE
  # I attempt to explain this insane code below and above.
  def update_wallet
    new_balance = 0

    case self.transaction_type
    when "buy"
      if self.share_amount == nil
        raise WalletError, "Cannot buy null shares"
      elsif self.share_amount < 0
        raise WalletError, "Cannot buy negative shares"
      end
      # call buy and get the array [investment.id, price, new_balance]
      id_price_array = self.buy(self.share_amount, self.stock_symbol)
      # update transaction retroactively with the correct data, as the test form (23/09/2025) can save it with inaccurate data
      Transaction.find(self.id).update!(price: id_price_array[1].exchange_to("PHP"), investment_id: id_price_array[0])
      new_balance = id_price_array[2]
      if self.wallet.balance_is_negative || new_balance < 0
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "sell"
      if self.wallet.user.user_status == "buyer_broker"
        # call sell and get the array [price, delete_this_investment, new_balance]
        sell_price_destroyed_array = self.sell(self.investment_id, self.share_amount, self.stock_symbol)
        new_balance = sell_price_destroyed_array[2]

        target_investment = Investment.find(self.investment_id)
        stock_symbol = Stock.find(target_investment.stock_id).symbol
        # update transaction retroactively with the correct data, as the test form (23/09/2025) can save it with inaccurate data
        Transaction.find(self.id).update!(price: sell_price_destroyed_array[0].exchange_to("PHP"), stock_symbol: stock_symbol)

        if sell_price_destroyed_array[1] == true
          Investment.destroy(target_investment.id)
        end
      else
        raise WalletError, "Cannot sell shares if not a broker"
      end
    when "withdraw"
      new_balance = self.wallet.subtract(self.price)

      # update transaction retroactively with the correct data, as the test form (23/09/2025) can save it with inaccurate data
      Transaction.find(self.id).update!(stock_symbol: nil, investment_id: nil)

      if self.wallet.balance_is_negative || new_balance < 0
        # Important to roll back the database
        raise WalletError, "Balance cannot be less than or equal to zero"
      end
    when "deposit"
      if self.price > 0
        new_balance = self.wallet.add(self.price)

        # update transaction retroactively with the correct data, as the test form (23/09/2025) can save it with inaccurate data
        Transaction.find(self.id).update!(stock_symbol: nil, investment_id: nil)
      else
        raise WalletError, "Cannot deposit negative amounts"
      end
    end

    # update wallet with new_balance
    self.wallet.update!(
      balance: new_balance
    )
  end
end
