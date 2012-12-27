require 'spec_helper'

describe LandingController do
  describe 'GET show' do
    before(:each) do
      get :show
    end
    specify { response.should be_success }
  end
end
