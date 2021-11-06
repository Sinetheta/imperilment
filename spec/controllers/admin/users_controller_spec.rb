require 'spec_helper'

describe Admin::UsersController do
  authorize_and_login

  let(:user) { create :admin }

  describe 'GET index' do
    it "assigns all users as @users" do
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user to @user' do
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'PUT grant_admin' do
    describe 'params[admin]' do
      context 'when "true"' do
        it 'adds the admin role to @user' do
          expect_any_instance_of(User).to receive(:add_role).with(:admin)
          put :grant_admin, params: { id: user.to_param, admin: 'true' }
        end
      end

      context 'when "false"' do
        it 'removes the admin role from @user'do
          expect_any_instance_of(User).to receive(:remove_role).with('admin')
          put :grant_admin, params: { id: user.to_param, admin: 'false' }
        end
      end
    end
  end

  describe 'PUT update' do
    describe "with valid params" do
      it "updates the requested user" do
        expect_any_instance_of(User).to receive(:update).with('first_name' => 'Joe')
        put :update, params: { id: user.to_param, user: { 'first_name' => 'Joe' } }
      end

      it "assigns the requested user as @user" do
        put :update, params: { id: user.to_param, user: { 'first_name' => 'Joe' } }
        expect(assigns(:user)).to eq(user)
      end

      it "redirects to the user" do
        put :update, params: { id: user.to_param, user: { 'first_name' => 'Joe' } }
        expect(response).to redirect_to([:admin, user])
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(User).to receive(:save).and_return(false)
        allow_any_instance_of(User).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: { id: user.to_param, user: { "email" => "invalid value" } }
        expect(assigns(:user)).to eq(user)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(User).to receive(:update).and_return(false)
        allow_any_instance_of(User).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: { id: user.to_param, user: { "email" => "invalid value" } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy ' do
    it "destroys the requested user" do
      expect do
        delete :destroy, params: { id: user.to_param }
      end.to change(User, :count).by(-1)
    end

    it "redirects to the user list" do
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(admin_users_url)
    end
  end
end
