require 'spec_helper'

describe WebHooksController do
  authorize

  let!(:web_hook) { create :web_hook }

  describe "GET index" do
    it "assigns all web hooks as @web_hooks" do
      get :index
      expect(assigns(:web_hooks)).to eq([web_hook])
    end
  end

  describe "GET new" do
    it "assigns a new web_hook as @web_hook" do
      get :new
      expect(assigns(:web_hook)).to be_a_new(WebHook)
    end
  end

  describe "POST create" do
    let(:default_params) { { web_hook: { url: 'http://www.example.com/fake_hook', active: true } } }
    subject(:valid_hook) { post :create, default_params }

    describe "with valid params" do
      it "creates a new WebHook" do
        expect{ valid_hook }.to change(WebHook, :count).by(1)
      end

      it "assigns a newly created web hook as @web_hook" do
        valid_hook
        expect(assigns(:web_hook)).to be_a(WebHook)
        expect(assigns(:web_hook)).to be_persisted
      end

      it "redirects to the web hook list" do
        expect(valid_hook).to redirect_to(web_hooks_url)
      end
    end

    describe "with invalid params" do
      subject(:invalid_hook) { post :create, web_hook: { url: 'nope' } }

      it "assigns a newly created but unsaved web hook as @web_hook" do
        invalid_hook
        expect(assigns(:web_hook)).to be_a(WebHook)
      end

      it "re-renders the 'new' template" do
        expect(invalid_hook).to render_template("new")
      end
    end
  end
end
