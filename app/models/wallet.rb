class Wallet < ApplicationRecord
  belongs_to :user
  monetize :balance_cents
  has_many :transactions
  has_many :investments

  def withdraw(amount)
    self.balance = self.balance - amount
    return self.balance
  end

  def deposit(amount)
    self.balance = self.balance + amount
    return self.balance
  end

  def add_investment(share_amount, stock_symbol)
    stock_data = Stock.find_by(symbol: stock_symbol)
    stock_price = stock_data.current_price
    investment = self.investments.create(total_share_amount: share_amount, buying_price: stock_price, stock_id: stock_data.id)
    price = share_amount * stock_price
    return [investment.id, price] # THIS IS IN USD AND WILL BE AUTOMATICALLY CONVERTED TO PHP BECAUSE OF THE SETUP IN money_rails_initializer
  end

  def remove_investment(investment_id, share_amount, stock_symbol)
    investment_data = Investment.find(investment_id)
    delete_this_investment = false
    puts investment_data.total_share_amount
    if (investment_data.total_share_amount > share_amount)
      new_share_amount = investment_data.total_share_amount - share_amount
      investment_data.update!(total_share_amount: new_share_amount)
    elsif (investment_data.total_share_amount == share_amount)
      delete_this_investment = true
    else
      raise WalletError, "Cannot sell more than total shares"
    end

    stock_data = Stock.find_by symbol: stock_symbol
    stock_price = stock_data.current_price

    price = share_amount * stock_price
    return [price, delete_this_investment] # THIS IS IN USD AND WILL BE AUTOMATICALLY CONVERTED TO PHP BECAUSE OF THE SETUP IN money_rails_initializer
  end

  def balance_is_negative
    if self.balance < 0
      return true
    else
      return false
    end
  end
end