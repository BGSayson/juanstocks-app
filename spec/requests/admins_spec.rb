require 'rails_helper'

RSpec.describe "Admins", type: :request do
  # Needs to be in every controller test for sign_in method to work
  include Devise::Test::IntegrationHelpers

  let(:testadmin) { create(:user)}
  let(:testuser) { create(:user, id: 2, user_role: :buyer, email: "jane@doe.com")}

  context "Routing" do
    it "should direct you to admins page if user is admin" do
      sign_in testadmin
      get admins_path
      expect(response).to have_http_status(:success)
    end

    it "should access all users page" do
      sign_in testadmin
      get all_users_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(/All Juanstocks Users/)
    end

    it "should access and list all admins page" do
      sign_in testadmin
      get all_admins_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(/All Juanstocks Admins/)
    end

    it "should access Show page of a user" do
      sign_in testadmin
      get user_path(testuser)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(/User details of:/)
    end

    it "should access New page to create a user" do  
      sign_in testadmin
      get new_admin_user_path(testuser)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(/User role/)
    end

    it "should access Edit page to edit a user" do  
      sign_in testadmin
      get edit_user_path(testuser)
      expect(response).to have_http_status(:success)
    end
end

  context "CRUD" do
    it "creates a user" do
      sign_in testadmin
      expect{
        post admin_users_path(testadmin), params: { user: { email: "test_one@test.com", password: "test_one_password", first_name:"Bien", last_name:"Sayson", user_status: :buyer_only, user_role: :buyer }} }.to change(User, :count).by(1)
    end

    it "updates a user" do
      sign_in testadmin
      testuser = create(:user, id: 3, first_name: "Jotaro", last_name: "Kujo", email: "dolphin@lover.com", password: "password", user_status: :buyer_only, user_role: :buyer )
      patch user_path(testuser), params: { user: {  first_name: "Jolyne", last_name: "Kujo", email: "dolphin@lover.com", password: "password", user_status: :buyer_only, user_role: :admin }} 
      testuser.reload
      expect(testuser.first_name).to eq("Jolyne")
    end

    it "deletes a user" do
      sign_in testadmin
      testuser = create(:user, id: 3, first_name: "Jotaro", last_name: "Kujo", email: "dolphin@lover.com", password: "password", user_status: :buyer_only, user_role: :buyer )
      expect{delete user_path(testuser)}.to change(User, :count).by(-1)
    end

  end

end
