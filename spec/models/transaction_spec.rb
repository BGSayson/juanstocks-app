require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
    @wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
    Money.locale_backend = nil
  end

  context "initial test" do
    it "creates test transaction" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100,"PHP"), transaction_type: 0, share_amount: 100)
      expect(transaction.price.format).to eq("₱1.00")
    end
  end

  context "validations" do
    it "has a valid transaction_type" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100,"PHP"), transaction_type: 0, share_amount: 100)
      expect(transaction.transaction_type_before_type_cast).to eq(0)
      expect(transaction.buy?).to eq(true)
    end
  end

  context "associations" do
    it "belong to a wallet" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100,"PHP") )
      expect(transaction.wallet.balance.format).to eq("₱1.00") 
    end
  end
  
  context "methods" do
    it "buys a share" do
      transaction = Transaction.new(wallet: @wallet, transaction_type: 0, share_amount: 100, price: Money.from_cents(100,"PHP") )
      transaction.buy(Money.from_cents(100, "PHP"))
      expect(@wallet.balance.format).to eq("₱0.00") 
    end

    it "cannot buy a share below 0" do
      wallet = Wallet.new(balance: Money.from_cents(0,"PHP"), user: @user)
      transaction = Transaction.new(wallet: @wallet, transaction_type: 0, share_amount: 100, price: Money.from_cents(100,"PHP") )
      transaction.buy(Money.from_cents(100, "PHP"))
      expect(wallet.balance.format).to eq("₱0.00") 
    end

    it "sells a share" do
      transaction = Transaction.new(wallet: @wallet, transaction_type: 1, share_amount: 100, price: Money.from_cents(50,"PHP") )
      transaction.sell(Money.from_cents(500, "PHP"))
      expect(@wallet.balance.format).to eq("₱5.00") 
    end
  end

end
