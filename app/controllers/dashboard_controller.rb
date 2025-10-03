class DashboardController < ApplicationController
  before_action :authenticate_user!

  # if current_user.user_role == :admin
  #   @admin = User.find(params[:id])
  # else
  #   redirect_to users_path
  # end

  def index
    @top_stocks = Stock.top_stocks
    @top_investments = current_user.wallet.investments.first(5)
    @recent_txs = current_user.wallet.transactions.recent_txs.first(8)
    if(current_user.user_role == 'admin')
      redirect_to admins_path 
    end
  end

  def verify_user
    if is_user_buyer_only
      puts "is_user_broker : #{is_user_buyer_only}"
      @user = User.find(current_user.id)
      if @user.update(user_status: "pending")
        flash[:notice] = "Verification now pending. Your application will be reviewed by our specialists."
        redirect_to dashboard_path
        nil
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
