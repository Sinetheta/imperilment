require 'spec_helper'

describe LandingController do
  describe 'GET show' do
    before(:each) do
      create :answer
      get :show
    end
    specify { response.should be_redirect }
  end
end
