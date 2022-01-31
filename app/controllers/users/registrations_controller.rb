class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def account_update_params
    params.require(:user).permit(:email, :display_name, :password, :password_confirmation, :current_password)
  end
end
