class TransactionsController < ApplicationController
  before_action :authenticate_user!
  rescue_from StandardError, with: :redirect

  def index
    if current_user_is_buyer_broker
      @transactions = current_user.wallet.transactions
    else
      @transactions = Transaction.all
    end
  end

  def new
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @transaction = Transaction.new
    else
      redirect_to root_path
    end
  end

  def create
    if current_user_is_buyer_broker
      @wallet = current_user.wallet
      @transaction = @wallet.transactions.build(transaction_params)

      if @transaction.save
        redirect_to wallet_path(@wallet.id)
      else
        p @transaction.errors.messages
        render :new
      end
    else
      redirect_to root_path
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:transaction_type, :share_amount, :price)
  end

  def current_user_is_buyer_broker
    current_user.user_role == "buyer" || current_user.user_role == 'broker'
  end

  def redirect
    @wallet = current_user.wallet
    redirect_to wallet_path(@wallet.id)
  end

end
