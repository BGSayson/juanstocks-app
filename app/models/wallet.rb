class Wallet < ApplicationRecord
  belongs_to :user
  monetize :balance_cents
  has_many :transactions
  has_many :investments

  def withdraw(amount)
    if self.balance >= amount
      self.balance = self.balance - amount
    end
    return self.balance
  end

  def deposit(amount)
    self.balance = self.balance + amount
    return self.balance
  end

  def add_investment(share_amount, stock_symbol)
    stock_data = Stock.find_by symbol: stock_symbol
    stock_price = stock_data.current_price
    self.investments.create(total_share_amount: share_amount, buying_price: stock_price, stock: stock_data)
    price = share_amount * stock_price * self.usd_exchange_rate
    return Money.new(price, 'PHP')
  end

  def remove_investment(investment_id, share_amount, stock_symbol)
    investment_data = Investment.find(investment_id)
    if (investment_data.total_share_amount > share_amount)
      new_share_amount = investment_data.total_share_amount - share_amount
      investment_data.update!(total_share_amount: new_share_amount)
    elsif (investment_data.total_share_amount == share_amount)
      Investment.destroy(investment_data.id)
    end

    stock_data = Stock.find_by symbol: stock_symbol
    stock_price = stock_data.current_price

    price = share_amount * stock_price * self.usd_exchange_rate
    return Money.new(price, 'PHP')
  end

  def balance_is_negative
    if self.balance > 0
      return true
    else
      return false
    end
  end
end