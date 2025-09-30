require 'rails_helper'

RSpec.describe Transaction, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:test_stock) { create(:stock) }
  let(:test_user) { create(:user) }
  let(:test_wallet) { create(:wallet, user: test_user) }
  let(:test_investment) { create(:investment, wallet: test_wallet, stock_id: test_stock.id) }

  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name: "Bien", last_name: "Sayson", user_status: 1, user_role: 1)
    @wallet = Wallet.new(balance: Money.from_cents(100, "PHP"), user: @user)
    @stock = Stock.new(currency: "PHP", description: "Sample Stock", display_symbol: "test url here", symbol: "SMPL", current_price: 10, current_price_currency: "PHP", change: 0.1, percent_change: 0.1, high_price_of_the_day: 1, low_price_of_the_day: 1, open_price_of_the_day: 1, previous_close_price: 1)
  end

  context "initial test" do
    it "creates test transaction" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100, "PHP"), transaction_type: 0, share_amount: 100)
      expect(transaction.price.format).to eq("₱1.00")
    end
  end

  context "validations" do
    it "has a valid transaction_type" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100, "PHP"), transaction_type: 0, share_amount: 100)
      expect(transaction.transaction_type_before_type_cast).to eq(0)
      expect(transaction.buy?).to eq(true)
    end
  end

  context "associations" do
    it "belong to a wallet" do
      transaction = Transaction.new(wallet: @wallet, price: Money.from_cents(100, "PHP"))
      expect(transaction.wallet.balance.format).to eq("₱1.00")
    end
  end

  context "methods" do
    it "buys a share" do
      Money.add_rate('USD', 'PHP', 1.0)
      transaction = Transaction.new(wallet: test_wallet)
      transaction.buy(1, test_stock.symbol)
      expect(test_wallet.investments.count).to eq(1)
      expect(test_wallet.balance).to eq(Money.new(2333, 'PHP'))
    end

    it "sells a share" do
      Money.add_rate('USD', 'PHP', 1.0)
      transaction = Transaction.new(wallet: test_wallet)
      sell_price_destroyed_array = transaction.sell(test_investment.id, 1, test_stock.symbol)
      expect(test_wallet.balance).to eq(Money.new(37667, 'PHP'))
      expect(sell_price_destroyed_array[1]).to eq(false)
    end
  end

  context "wallet update method switches" do
    it "successful transaction_type : buy" do
      Money.add_rate('USD', 'PHP', 1.0)
      transaction = Transaction.create(transaction_type: "buy", share_amount: 1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      expect(test_wallet.balance).to eq(Money.new(2333, 'PHP'))
      expect(transaction.reload.price).to eq(Money.new(17667, 'PHP'))
      expect(transaction.reload.investment_id).not_to eq(test_investment.id)
    end

    it "buy failure : cannot buy negative shares" do
      Money.add_rate('USD', 'PHP', 1.0)
      expect {
        transaction = Transaction.create(transaction_type: "buy", share_amount: -1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      } .to raise_error(an_instance_of(WalletError).and having_attributes(message: "Cannot buy negative shares"))
    end

    it "buy failure : negative final balance" do
      Money.add_rate('USD', 'PHP', 1.0)
      expect {
        transaction = Transaction.create(transaction_type: "buy", share_amount: 2, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      } .to raise_error(an_instance_of(WalletError).and having_attributes(message: "Balance cannot be less than or equal to zero"))
    end

    it "successful transaction_type : sell" do
      Money.add_rate('USD', 'PHP', 1.0)
      transaction = Transaction.create(transaction_type: "sell", share_amount: 1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      expect(test_wallet.balance).to eq(Money.new(37667, 'PHP'))
      expect(transaction.reload.price).to eq(Money.new(17667, 'PHP'))
      expect(test_investment.reload.total_share_amount).to eq(99)
    end

    it "sell failure : impossible share amount" do
      Money.add_rate('USD', 'PHP', 1.0)
      expect {
        transaction = Transaction.create(transaction_type: "sell", share_amount: 10000, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      } .to raise_error(an_instance_of(WalletError).and having_attributes(message: "Cannot sell more than total shares"))
    end

    it "successful transaction_type : withdraw" do
      transaction = Transaction.create(transaction_type: "withdraw", share_amount: 1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      expect(test_wallet.balance).to eq(Money.new(19000, 'PHP'))
      expect(transaction.reload.stock_symbol).to eq(nil)
      expect(transaction.reload.investment_id).to eq(nil)
    end

    it "withdraw failure : negative balance" do
      expect {
        transaction = Transaction.create(transaction_type: "withdraw", share_amount: 1, price: 10000, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      } .to raise_error(an_instance_of(WalletError).and having_attributes(message: "Balance cannot be less than or equal to zero"))
    end

    it "successful transaction_type : deposit" do
      transaction = Transaction.create(transaction_type: "deposit", share_amount: 1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      expect(test_wallet.balance).to eq(Money.new(21000, 'PHP'))
      expect(transaction.reload.stock_symbol).to eq(nil)
      expect(transaction.reload.investment_id).to eq(nil)
    end

    it "deposit failure : negative deposit" do
      expect {
        transaction = Transaction.create(transaction_type: "deposit", share_amount: 1, price: -10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet)
      } .to raise_error(an_instance_of(WalletError).and having_attributes(message: "Cannot deposit negative amounts"))
    end
  end
end
