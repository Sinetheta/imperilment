class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  respond_to :html, :json

  def index
    respond_with :admin, @users
  end

  def edit
    respond_with :admin, @user
  end

  def grant_admin
    if params[:admin] == 'true'
      @user.add_role :admin
    elsif params[:admin] == 'false'
      @user.remove_role 'admin'
    end
    respond_with :admin, @user do |format|
      format.js { head :ok }
    end
  end

  def show
    respond_with :admin, @user
  end

  def update
    if @user.update_attributes(user_params)
      flash.notice = t :model_update_successful, model: User.model_name.human
    end
    respond_with :admin, @user
  end

  def destroy
    @user.destroy
    respond_with @user, location: admin_users_path
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :in_office
  end
end
