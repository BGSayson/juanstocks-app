require 'rails_helper'

RSpec.describe "Welcomes", type: :request do

  context "landing/welcome page" do
    it "can be accessed without verifying/login" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
