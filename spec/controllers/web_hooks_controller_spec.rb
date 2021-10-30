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

  describe "GET edit" do
    it "assigns the requested web hook as @web_hook" do
      get :edit, id: web_hook.to_param
      expect(assigns(:web_hook)).to eq(web_hook)
    end
  end

  describe "POST create" do
    subject { post :create, request_params }

    context "with valid params" do
      let(:request_params) { { web_hook: { url: 'http://www.example.com/fake_hook', active: true } } }

      it "creates a new WebHook" do
        expect{ subject }.to change(WebHook, :count).by(1)
      end

      describe 'controller instance variables' do
        before do
          subject
        end
        it "sets @web_hook" do
          expect(assigns(:web_hook)).to be_a(WebHook)
        end
        it 'persists @web_hook' do
          expect(assigns(:web_hook)).to be_persisted
        end
      end

      it "redirects to the web hook list" do
        expect(subject).to redirect_to(web_hooks_url)
      end
    end

    context "with invalid params" do
      let(:request_params) { { web_hook: { url: nil } } }

      it "assigns a newly created but unsaved web hook as @web_hook" do
        subject
        expect(assigns(:web_hook)).to be_a(WebHook)
      end

      it "re-renders the 'new' template" do
        expect(subject).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested web hook" do
        expect_any_instance_of(WebHook).to receive(:update).with({ url: 'http://www.example.com/new_hook' })
        put :update, id: web_hook.to_param, web_hook: { url: 'http://www.example.com/new_hook' }
      end

      it "assigns the requested web hook as @web_hook" do
        put :update, id: web_hook.to_param, web_hook: { url: 'http://www.example.com/new_hook' }
        expect(assigns(:web_hook)).to eq(web_hook)
      end

      it "redirects to the web hook list" do
        put :update, id: web_hook.to_param, web_hook: { url: 'http://www.example.com/new_hook' }
        expect(response).to redirect_to(web_hooks_url)
      end
    end

    describe "with invalid params" do
      it "assigns the web hook as @web_hook" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(WebHook).to receive(:save).and_return(false)
        allow_any_instance_of(WebHook).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, id: web_hook.to_param, web_hook: { url: 'invalid_hook' }
        expect(assigns(:web_hook)).to eq(web_hook)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(WebHook).to receive(:save).and_return(false)
        allow_any_instance_of(WebHook).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, id: web_hook.to_param, web_hook: { url: 'invalid_hook' }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested web hook" do
      expect {
        delete :destroy, id: web_hook.to_param
      }.to change(WebHook, :count).by(-1)
    end

    it "redirects to the web hooks list" do
      delete :destroy, id: web_hook.to_param
      expect(response).to redirect_to(web_hooks_url)
    end
  end

end
