require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  include Devise::Test::IntegrationHelpers
  # pending "add some examples (or delete) #{__FILE__}"
  let(:test_stock) { create(:stock)}
  let(:test_user) {create(:user, user_role: :broker)}

  context "Routing" do
    it "stock index view" do
      sign_in test_user
      get stocks_path
      expect(response).to have_http_status(:success)
    end

    it "stock show view" do
      sign_in test_user
      get stock_path(test_stock.id)
      expect(response).to have_http_status(:success)
    end
  end
end
