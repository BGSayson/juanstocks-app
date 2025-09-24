class WalletsController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @transactions = @wallet.transactions.order(:id).last(5)
      @investments = @wallet.investments.order(total_share_amount: :desc).first(5)
    else
      redirect_to root_path
    end
  end

  # def edit
  #   if current_user_is_buyer_broker
  #     @wallet = Wallet.find(params[:id])
  #   else
  #     redirect_to root_path
  #   end
  # end

  # def update
  #   if current_user_is_buyer_broker
  #     @wallet = Wallet.find(params[:id])

  #     if @wallet.update(wallet_params)
  #     redirect_to wallet_path(current_user.wallet.id)
  #     else
  #       p @wallet.errors.messages
  #     end
  #   else
  #     redirect_to root_path
  #   end
  # end

  private
  def wallet_params
    params.require(:wallet).permit(:balance, :user)
  end

  def current_user_is_buyer_broker
    current_user.user_role != "admin"
  end

end
