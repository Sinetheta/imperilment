class Users::RegistrationsController < Devise::RegistrationsController

  def create
    # If the avatar_url param is blank, we
    #   want to set it to nil for storing in the db
    params[:user][:avatar_url] = params[:user][:avatar_url].presence
    super
  end
  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :avatar_url)
  end
end
