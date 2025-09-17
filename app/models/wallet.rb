class Wallet < ApplicationRecord
  belongs_to :user
  monetize :balance_cents

  def withdraw(amount)
    if self.balance >= amount
      self.balance = self.balance - amount
    end
  end

  def deposit(amount)
    self.balance = self.balance + amount
  end
end