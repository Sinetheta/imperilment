require 'spec_helper'

describe Users::RegistrationsController do
  describe ".update" do
    let!(:user) { create :user, display_name: 'old username' }

    authorize_and_login

    it "allows a user to update their display_name without a password confirmation" do
      put :update, params: { user: { display_name: 'new username' } }
      expect(response).to redirect_to('/')
      expect(user.reload.display_name).to eq('new username')
    end
  end
end
