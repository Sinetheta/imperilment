require 'spec_helper'

describe Users::OmniauthCallbacksController do
  describe ".all" do
    let!(:user) { create :user }

    before(:each) do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
      OmniAuth.config.mock_auth[:google].info.email = user.email
    end

    it "assigns user to @user" do
      get :google, params: { email: "test@facebook.com" }
      expect(assigns(:user)).to eq(user)
    end

    it "signs the user in" do
      get :google
      expect(subject.current_user).to eq(user)
    end

    it "redirects to the dashboard" do
      session[:"user.return_to"] = '/'
      get :google
      expect(response).to redirect_to '/'
    end
  end
end
