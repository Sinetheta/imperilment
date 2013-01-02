require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end
  describe 'GET show' do
    before(:each) do
      get :index, format: :json
    end
    specify { response.status.should == 403 }
  end
end
