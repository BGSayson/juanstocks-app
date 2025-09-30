require 'rails_helper'

RSpec.describe "Users", type: :request do
  # describe "GET /index" do
  #   pending "add some examples (or delete) #{__FILE__}"
  # end
  include Devise::Test::IntegrationHelpers

  # let(:testadmin) { User.new(first_name: "Kelcie", last_name: "Lord", user_role: 1, user_status: 1 ) }

  let(:testbuyer) { create(:user, user_role: :buyer) }
  let(:test_stock) { create(:stock) }

  context "Access to Trader Dashboard" do
    it "Must direct you to dashboard page" do
      sign_in testbuyer
      test_stock
      get dashboard_path
      expect(response).to have_http_status(:success)
    end
  end
end
