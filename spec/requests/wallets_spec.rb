require 'rails_helper'

RSpec.describe "Wallets", type: :request do
  include Devise::Test::IntegrationHelpers
  # pending "add some examples (or delete) #{__FILE__}"
  let(:test_user) { create(:user, user_role: :broker) }

  context "Routing" do
    it "wallet show view" do
      sign_in test_user
      get wallet_path(test_user.wallet.id)
      expect(response).to have_http_status(:success)
    end
  end
end
