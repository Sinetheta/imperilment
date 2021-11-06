require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      fail CanCan::AccessDenied
    end
  end
  describe 'GET show' do
    before(:each) do
      get :index, params: { format: :json }
    end
    specify { expect(response.status).to eq(403) }

    context "when ?profile=true" do
      it "should authorize the request for mini-profiler" do
        expect(Rack::MiniProfiler).to receive(:authorize_request)
        get :index, params: { format: :json, profile: true }
      end
    end
  end
end
