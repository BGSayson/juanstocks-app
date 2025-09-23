class DashboardController < ApplicationController
  before_action :authenticate_user!

  # if current_user.user_role == :admin
  #   @admin = User.find(params[:id])
  # else
  #   redirect_to users_path
  # end

  def index
  end
end
