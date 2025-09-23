class InvestmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @investments = @wallet.investments
    else
      redirect_to root_path
    end
  end

  # def new
  #   if current_user_is_buyer_broker
  #     @wallet = current_user.wallet
  #     @investment = Investment.new
  #   else
  #     redirect_to root_path
  #   end
  # end

  # def create
  #   if current_user_is_buyer_broker
  #     @wallet = current_user.wallet
  #     @investment = Investment.new(investment_params)

  #     if @investment.save
  #       redirect_to wallet_investments_path(@wallet.id)
  #     else
  #       render :new
  #     end
  #   else
  #     redirect_to root_path
  #   end
  # end

  def show
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @investment = Investment.find(params[:id])
    else
      redirect_to root_path
    end
  end

  # def edit
  #   if current_user_is_buyer_broker
  #     @investment = Investment.find(params[:id])
  #   else
  #     redirect_to root_path
  #   end
  # end

  # def update
  #   if current_user_is_buyer_broker
  #     @investment = Investment.find(params[:id])

  #     if @investment.update(wallet_params)
  #     redirect_to investment_path(params[:id])
  #     else
  #       p @investment.errors.messages
  #     end
  #   else
  #     redirect_to root_path
  #   end
  # end

  def destroy
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @investment = Investment.find(params[:id])

      if @investment.destroy
        redirect_to wallet_investments_path(@wallet.id)
      else
        p @investment.errors.messages
      end
    else
      redirect_to root_path
    end
  end

  private
  def investment_params
    params.require(:investment).permit(:total_share_amount, :buying_price)
  end

  def current_user_is_buyer_broker
    current_user.user_role != "admin"
  end

end
