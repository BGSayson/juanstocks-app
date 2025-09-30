require 'rails_helper'

RSpec.describe "Investments", type: :request do
  include Devise::Test::IntegrationHelpers
  # pending "add some examples (or delete) #{__FILE__}"
  let(:test_stock) { create(:stock) }
  let(:test_user) { create(:user, user_role: :broker) }
  let(:test_wallet) { create(:wallet, user: test_user) }
  let(:test_investment) { create(:investment, wallet: test_wallet, stock_id: test_stock.id) }

  context "Routing" do
    it "investment index view" do
      sign_in test_user
      get wallet_investments_path(test_wallet.id)
      expect(response).to have_http_status(:success)
    end

    it "investment show view" do
      sign_in test_user
      get investment_path(test_investment.id)
      expect(response).to have_http_status(:success)
    end
  end
end
