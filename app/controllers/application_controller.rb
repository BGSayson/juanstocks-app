class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?


    def configure_permitted_parameters
      added_attrs = [ :first_name, :last_name, :email, :password, :password_confirmation, :remember_me ]
      devise_parameter_sanitizer.permit(:sign_up, keys: [ added_attrs ])
      devise_parameter_sanitizer.permit(:account_update, keys: [ added_attrs ])
      # devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
      # devise_parameter_sanitizer.permit(:account_update, keys: [ :username ])
    end


  def after_sign_in_path_for(resource)
    if current_user.user_role == "admin"
      @admin = User.find(params[:id])
      admins_path
    else
      dashboard_path
    end 
  end

  def after_sign_up_path_for(resource)
    dashboard_path # your path
  end

  def after_sign_out_path_for(resource)
    root_path # your path
  end
end
