require 'spec_helper'

describe Admin::UsersController do
  authorize_and_login

  let(:user) { create :admin }

  describe 'GET index' do
    it "assigns all users as @users" do
      get :index
      assigns(:users).should eq([user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user to @user' do
      get :show, id: user.to_param
      assigns(:user).should eq(user)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user to @user' do
      get :edit, id: user.to_param
      assigns(:user).should eq(user)
    end
  end

  describe 'PUT grant_admin' do
    describe 'params[admin]' do
      context 'when "true"' do
        it 'adds the admin role to @user' do
          User.any_instance.should_receive(:add_role).with(:admin)
          put :grant_admin, id: user.to_param, admin: 'true'
        end
      end

      context 'when "false"' do
        it 'removes the admin role from @user'do
          User.any_instance.should_receive(:remove_role).with('admin')
          put :grant_admin, id: user.to_param, admin: 'false'
        end
      end
    end
  end

  describe 'PUT update' do

    describe "with valid params" do
      it "updates the requested user" do
        User.any_instance.should_receive(:update_attributes).with({'first_name' => 'Joe'})
        put :update, id: user.to_param, user: { 'first_name' => 'Joe' }
      end

      it "assigns the requested user as @user" do
        put :update, id: user.to_param, user: {}
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        put :update, id: user.to_param, user: {}
        response.should redirect_to([:admin, user])
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        User.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: user.to_param, user: { "email" => "invalid value" }
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:update_attributes).and_return(false)
        User.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: user.to_param, user: { "email" => "invalid value" }
        response.should render_template("edit")
      end
    end
  end

  describe 'DELETE destroy ' do
    it "destroys the requested user" do
      expect {
        delete :destroy, id: user.to_param
      }.to change(User, :count).by(-1)
    end

    it "redirects to the user list" do
      delete :destroy, id: user.to_param
      response.should redirect_to(admin_users_url)
    end

  end
end
