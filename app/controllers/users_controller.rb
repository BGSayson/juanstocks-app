class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path # /articles
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
    redirect_to admin_users_path
    else
      p @user.errors.messages
    end
  end
  
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      redirect_to admin_users_path
    else
      p @user.errors.messages
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_role, :user_status)
  end
end
