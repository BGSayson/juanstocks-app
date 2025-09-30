require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  include Devise::Test::IntegrationHelpers
  # pending "add some examples (or delete) #{__FILE__}"

  let(:test_stock) { create(:stock) }
  let(:test_user) { create(:user, user_role: :broker) }
  let(:test_wallet) { create(:wallet, user: test_user) }
  let(:test_investment) { create(:investment, wallet: test_wallet, stock_id: test_stock.id) }

  context "Routing" do
    it "transaction index view" do
      sign_in test_user
      get wallet_transactions_path(test_wallet.id)
      expect(response).to have_http_status(:success)
    end

    it "transaction new view" do
      sign_in test_user
      get new_wallet_transaction_path(test_wallet.id)
      expect(response).to have_http_status(:success)
    end
  end

  context "CRUD" do
    it "creates a transaction" do
      sign_in test_user
      expect {
        post wallet_transactions_path(test_user), params: { transaction: { transaction_type: "deposit", share_amount: 1, price: 10, stock_symbol: test_stock.symbol, investment_id: test_investment.id, wallet: test_wallet } }
      }.to change(Transaction, :count).by(1)
    end
  end
end
