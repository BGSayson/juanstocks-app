class AdminsController < ApplicationController
  before_action :authenticate_user!

  def index
    @admins = Admin.all
  end

  def show
    @admin = Admin.find(params[:id])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(user_params)

    if @admin.save
      redirect_to admin_users_path # /articles
    else
      render :new
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])

    if @admin.update(user_params)
    redirect_to admin_users_path
    else
      p @admin.errors.messages
    end
  end
  
  def destroy
    @admin = User.find(params[:id])

    if @admin.destroy
      redirect_to admin_users_path
    else
      p @admin.errors.messages
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_role, :user_status)
  end

end
