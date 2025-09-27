class AdminsController < ApplicationController
  before_action :authenticate_user!

  def index
    if is_user_admin
      @users = User.where.not(user_role: 'admin')
      @buyers = User.where(user_role: 'buyer').or(User.where(user_role: 'broker'))
      @brokers = User.where(user_role: 'broker')
      @transactions = Transaction.all
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def all_users
    if is_user_admin
      @users = User.all
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def all_pending_users
    if is_user_admin
      @users = User.where(user_status: :pending)
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def all_admins
    if is_user_admin
      @admins = User.where(user_role: 'admin')
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def all_transactions
    if is_user_admin
      @transactions = Transaction.all
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def view_transaction
    if is_user_admin
      @transaction = Transaction.find(params[:id])
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end

  end

  def show
    if is_user_admin
      @admin = User.find(params[:id])
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def new
    if is_user_admin 
      @admin = User.new
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def create
    if is_user_admin
      @admin = User.new(user_params)

      if params[:commit] == "Submit and Confirm immediately"
        @admin.skip_confirmation!
        @admin.save
        flash[:notice] = "User created successfully and email is simulatenously confirmed"
        redirect_to all_users_path
        return
       else
        @admin.save
        render all_users_path
        return
      end
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def edit
    if is_user_admin
      @user = User.find(params[:id])
      render :edit
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def update
    if is_user_admin
      @user = User.find(params[:id])

      if @user.update(user_params)
        flash[:notice] = "User credentials changed successfully"
        redirect_to user_path(@user)
        return
      else
        flash[:alert] = "User credentials couldn't be saved"
        redirect_to edit_user_path(@user)
        return
      end
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end
  
  def destroy
    if is_user_admin
      @admin = User.find(params[:id])

      if @admin.destroy
        redirect_to admin_users_path
      else
        p @admin.errors.messages
      end
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_role, :user_status)
  end

  def is_user_admin
    current_user.user_role == "admin"
  end
end
