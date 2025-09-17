require 'rails_helper'

RSpec.describe Wallet, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
    Money.locale_backend = nil
  end

  context "initial test" do
    it "creates test wallet" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      expect(wallet.balance.format).to eq("₱1.00")
    end
  end

  context "associations" do
    # balance cannot be nil as specified in create_wallets migration file
    it "belong to a user" do
      wallet = Wallet.new(balance: nil, user: @user)
      expect(wallet.user.first_name).to eq("Bien") 
    end
  end

  context "methods" do
    it "can deposit" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      wallet.deposit(Money.from_cents(100, "PHP"))
      expect(wallet.balance.format).to eq("₱2.00")
    end

    it "can withdraw" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      wallet.withdraw(Money.from_cents(100, "PHP"))
      expect(wallet.balance.format).to eq("₱0.00")
    end

    it "cannot withdraw below 0" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      wallet.withdraw(Money.from_cents(200, "PHP"))
      expect(wallet.balance.format).to eq("₱1.00")
    end
  end
end
