require 'spec_helper'

describe WebHooksController do
  authorize

  let!(:web_hook) { create :web_hook }
  let(:default_params) { { web_hook: { url: 'http://www.example.com/fake_hook', active: true } } }

  describe "GET index" do
    it "assigns all web hooks as @web_hooks" do
      get :index
      expect(assigns(:web_hooks)).to eq([web_hook])
    end
  end
end
