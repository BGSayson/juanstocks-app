class Wallet < ApplicationRecord
  belongs_to :user
  monetize :balance_cents
  has_many :transactions
  has_many :investments

  def subtract(amount)
    # withdraws/subtracts amount from the wallet
    # balance and amount checking is done with update_wallet so it's okay if it's negative. it will be caught by update_wallet's error handling
    self.balance = self.balance - amount
    self.balance
  end

  def add(amount)
    # deposits/adds amount from the wallet
    # balance and amount checking is done with update_wallet so it's okay if it's negative. it will be caught by update_wallet's error handling
    self.balance = self.balance + amount
    self.balance
  end

  def add_investment(share_amount, stock_symbol)
    # retrieve specific stock object from the stock table by searching with stock_symbol
    stock_data = Stock.find_by(symbol: stock_symbol)

    # retrieve stock price from stock_data object
    stock_price = stock_data.current_price

    investment_id = nil
    existing_investment = nil
    self.investments.each do |inv|
      if Stock.find(inv.stock_id).symbol == stock_symbol
        existing_investment = inv
        break
      end
    end

    # create a new investment
    # total_share_amount : share_amount <= from method params
    # buying_price : stock_price <= from retrieved data
    # stock_id : stock_data.id <= from retrieved data
    if existing_investment == nil
      investment = self.investments.create(total_share_amount: share_amount, buying_price: stock_price, stock_id: stock_data.id)
      investment_id = investment.id
    else
      new_share_total = existing_investment.total_share_amount+share_amount
      existing_investment.update(total_share_amount: new_share_total)
      investment_id = existing_investment.id
    end
    # price to be charged to the user
    price = share_amount * stock_price
    # return an array
    # investment.id : to update transaction table for accurate data reflection
    # price : USD currency which will be auto-converted to wallet's PHP currency
    [ investment_id, price ]
  end

  def remove_investment(investment_id, share_amount, stock_symbol)
    # retrieve specific investment object from the investment table by searching with investment_id
    investment_data = Investment.find(investment_id)

    # delete_this_investment : a boolean to tell transaction if the investment object should be deleted
    delete_this_investment = false

    # if total_share_amount is more than the share_amount that will be sold by the user
    if investment_data.total_share_amount > share_amount
      new_share_amount = investment_data.total_share_amount - share_amount
      # updates investment_data object with the new share amount
      investment_data.update!(total_share_amount: new_share_amount)
    elsif investment_data.total_share_amount == share_amount
      # if total_share_amount is equal to share_amount, the object should be deleted
      delete_this_investment = true
    else
      # if total_share_amount is less than the share_amount that user wants to sell
      # raise the error that will roll back the database
      raise CustomError::WalletError, "Cannot sell more than total shares"
    end

    # retrieve a specific stock object by searching with stock_symbol and calculate selling price by multiplying the current stock price with the share_amount
    stock_data = Stock.find_by symbol: stock_symbol
    stock_price = stock_data.current_price
    price = share_amount * stock_price

    # return an array
    # price : USD currency which will be auto-converted to wallet's PHP currency
    # delete_this_investment : boolean that tells the transaction controller if the current investment should be deleted
    [ price, delete_this_investment ]
  end

  def balance_is_negative
    if self.balance < 0
      true
    else
      false
    end
  end
end
