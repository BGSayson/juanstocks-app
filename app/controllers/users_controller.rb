class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    if is_user_admin
    @users = User.all
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def show
    if is_user_admin
      @user = User.find(params[:id])
      @wallet = @user.wallet
      @transactions = @wallet.transactions.order(:id)
      @investments = @wallet.investments.order(:id)
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def all_pending_users
    if is_user_admin
      @users = User.pending_users
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def confirm_user
    if is_user_admin
      @user = User.find(params[:id])

      if @user.confirm
        flash[:notice] = "User email confirmed successfully"
        redirect_to user_path(@user)
        nil
      else
        render :show
      end
    end
  end


  def new
    if is_user_admin
      @user = User.new
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def create
    if is_user_admin
      @user = User.new(user_params)

      if params[:commit] == "Submit and Confirm immediately"
        @user.skip_confirmation!
        if @user.save
          flash[:notice] = "User created successfully and email is simultaneously confirmed"
          redirect_to user_path(@user) and return
        end
      else
        if @user.save
          flash[:notice] = "User created successfully"
          redirect_to user_path(@user) and return
        end
      end
      redirect_to new_admin_user_path, alert: "Unable to create user"
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
        nil
      else
        flash[:alert] = "User credentials couldn't be saved"
        redirect_to edit_user_path(@user)
        nil
      end
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  def destroy
    if is_user_admin
      @user = User.find(params[:id])

      if @user.destroy
        redirect_to all_users_path
        nil
      else
        p @user.errors.messages
      end
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_role, :user_status, :email, :password,)
  end

  def is_user_admin
    current_user.user_role == "admin"
  end
end
