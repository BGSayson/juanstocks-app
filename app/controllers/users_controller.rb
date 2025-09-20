require 'httparty'

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
        return
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
        @user.save
        flash[:notice] = "User created successfully and email is simultaneously confirmed"
        redirect_to user_path(@user) and return
       else
        flash[:notice] = "User created successfully"
        @user.save
        redirect_to user_path(@user) and return
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
      @user = User.find(params[:id])

      if @user.destroy
        redirect_to all_users_path
        return 
      else
        p @user.errors.messages
      end
    else
      redirect_to dashboard_path, alert: "User is unauthorized"
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_role, :user_status, :email, :password, )
  end

  def is_user_admin
    current_user.user_role == "admin"
  end
end
