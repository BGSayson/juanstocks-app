require 'rails_helper'

RSpec.describe Wallet, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:test_stock) { create(:stock)}
  let(:test_user) {create(:user)}
  let(:test_wallet) {create(:wallet, user: test_user)}

  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
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

    it "balance_is_negative returns true if balance is below 0" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      wallet.withdraw(Money.from_cents(200, "PHP"))
      expect(wallet.balance_is_negative).to eq(true)
    end

    it "can add investment" do
      id_price_array = test_wallet.add_investment(1, test_stock.symbol)
      expect(id_price_array[0]).to eq(test_wallet.investments.first.id)
      expect(id_price_array[1]).to eq(Money.new(17667, 'USD'))
    end

    it "can remove invesment" do
      test_investment = test_wallet.investments.create(total_share_amount: 1, buying_price: 1, stock_id: test_stock.id)
      price_delete_array = test_wallet.remove_investment(test_investment.id, 1, test_stock.symbol)
      expect(price_delete_array[0]).to eq(Money.new(17667, 'USD'))
      expect(price_delete_array[1]).to eq(true)
    end

    it "remove invesment failure : impossible share amount" do
      test_investment = test_wallet.investments.create(total_share_amount: 1, buying_price: 1, stock_id: test_stock.id)
      expect {
        price_delete_array = test_wallet.remove_investment(test_investment.id, 100, test_stock.symbol) 
      }.to raise_error(an_instance_of(WalletError).and having_attributes(message: "Cannot sell more than total shares"))
    end
  end
end
