class DashboardController < ApplicationController
  before_action :authenticate_user!

  # if current_user.user_role == :admin
  #   @admin = User.find(params[:id])
  # else
  #   redirect_to users_path
  # end

  def index
  end

  def verify_user
    if is_user_buyer_only
      puts "is_user_broker : #{is_user_buyer_only}"
      @user = User.find(current_user.id)
      if @user.update(user_status: "buyer_broker")
        flash[:alert] = "User verified!"
        redirect_to dashboard_path
        return
      end

    else 
      flash[:alert] = "HUHHHHHHHH"
      redirect_to dashboard_path
    end
  end

  private
  def is_user_buyer_only
    current_user.user_status == "buyer_only"
  end
end
