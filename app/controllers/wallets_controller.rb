class WalletsController < ApplicationController
  before_action :authenticate_user!

  def show
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      puts "AAAA"
      @wallet = current_user.wallet
      @transactions = @wallet.transactions
    else
      puts "BBBB"
      redirect_to root_path
    end
  end

  def edit
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      @wallet = Wallet.find(params[:id])
    else
      redirect_to root_path
    end
  end

  def update
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      @wallet = Wallet.find(params[:id])

      if @wallet.update(wallet_params)
      redirect_to wallet_path(current_user.wallet.id)
      else
        p @wallet.errors.messages
      end
    else
      redirect_to root_path
    end
  end

  private
  def wallet_params
    params.require(:wallet).permit(:balance, :user)
  end

end
