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

  def balance_is_negative
    if self.balance < 0
      return true
    else
      return false
    end
  end
end