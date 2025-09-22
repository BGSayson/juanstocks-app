require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before :all do
    @user = User.new(email: "test_one@test.com", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
    Money.locale_backend = nil
  end

  context "initial test" do
    it "creates test user" do
      expect(@user.first_name).to eq("Bien")
    end
  end

  context "validations" do
    it "has a first name that cannot be blank" do
      user = User.new
      expect(user).not_to be_valid
    end

    it "has a last name that cannot be blank" do
      user = User.new
      expect(user).not_to be_valid
    end

    # devise automatically disallows emails and passwords to be blank
    it "has an email that cannot be blank" do
      user = User.new(email: "", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
      expect(user).not_to be_valid
    end

    it "has a password that cannot be blank" do
      user = User.new(email: "test@test.com", password: "", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
      expect(user).not_to be_valid
    end

    it "has a password with at least 6 characters" do
      user = User.new(email: "test@test.com", password: "asdf", first_name:"Bien", last_name:"Sayson", user_status: 1, user_role: 1)
      expect(user).not_to be_valid
    end

    # enum attribute inherently disallows assigning values that are not assigned in the enum 
    it "has a valid user status" do
      # expect(@user.user_status).to eq(1)
      expect(@user.user_status_before_type_cast).to eq(1)
      expect(@user.buyer_broker?).to eq(true)
    end
    it "has a valid user role" do
      # expect(@user.user_role).to eq(1)
      expect(@user.user_role_before_type_cast).to eq(1)
      expect(@user.admin?).to eq(true)
    end
  end

  context "associations" do
    it "has one wallet" do
      wallet = Wallet.new(balance: Money.from_cents(100,"PHP"), user: @user)
      expect(@user.wallet.balance.format).to eq("₱1.00")
      expect(wallet.user).to eq(@user)
    end
  end
end