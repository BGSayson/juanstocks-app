require 'rails_helper'

RSpec.describe "Admins", type: :request do
  # Needs to be in every controller test for sign_in method to work
  include Devise::Test::IntegrationHelpers

  let(:testadmin) { User.new(first_name: "Kelcie", last_name: "Lord", user_role: 1, user_status: 1 ) }
  
  setup do
    @user = :testadmin
    sign_in @user
  end

  context "get admin index" do
    it "gets admin index" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

end
