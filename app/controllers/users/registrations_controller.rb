class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def account_update_params
    params.require(:user).permit(:email, :display_name, :password, :password_confirmation)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
