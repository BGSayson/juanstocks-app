require 'rails_helper'

RSpec.describe Investment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  let(:test_stock) { create(:stock) }
  let(:test_user) { create(:user) }
  let(:test_wallet) { create(:wallet, user: test_user) }
  let(:test_investment) { create(:investment, wallet: test_wallet, stock_id: test_stock.id) }

  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name: "Bien", last_name: "Sayson", user_status: 1, user_role: 1)
    @wallet = Wallet.new(balance: Money.from_cents(100, "PHP"), user: @user)
  end

  context "initial test" do
    it "creates investment" do
      investment = Investment.new(total_share_amount: 10, wallet: @wallet, buying_price: Money.from_cents(100, "PHP"))
      expect(investment.buying_price.format).to eq("₱1.00")
    end
  end

  context "associations" do
    it "belongs to a wallet" do
      investment = Investment.new(total_share_amount: 10, wallet: @wallet, buying_price: Money.from_cents(100, "PHP"))
      expect(investment.wallet.balance.format).to eq("₱1.00")
    end
  end

  context "validations" do
    it "must have an amount greater than or equal to 1 and cannot be nil" do
      investment_a = Investment.new(total_share_amount: "", wallet: @wallet, buying_price: Money.from_cents(100, "PHP"))
      investment_b = Investment.new(total_share_amount: "0", wallet: @wallet, buying_price: Money.from_cents(100, "PHP"))
      expect(investment_a).not_to be_valid
      expect(investment_b).not_to be_valid
    end
  end

  context "methods" do
    it "must return the right investment_display text" do
      text_display = test_investment.investment_display
      expect(text_display).to eq("[ 100 Shares ] NVIDIA Corp")
    end
  end
end
