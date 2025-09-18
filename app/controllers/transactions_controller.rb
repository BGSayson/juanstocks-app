class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      @transactions = current_user.wallet.transactions
    else
      @transactions = Transaction.all
    end
  end

  def new
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      @wallet = current_user.wallet
      @transaction = Transaction.new
    else
      redirect_to root_path
    end
  end

  def create
    if(current_user.user_role == "buyer" || current_user.user_role == "broker" )
      @wallet = current_user.wallet
      @transaction = Transaction.new(transaction_params)

      if @transaction.save
        case @transaction.transaction_type
        when :buy
          p "buy"
        when :sell
          p "sell"
        when :withdraw
          p "withdraw"
        when :deposit
          p "deposit"
        end
        redirect_to wallet_investments_path(@wallet.id)
      else
        render :new
      end
    else
      redirect_to root_path
    end
  end

end
