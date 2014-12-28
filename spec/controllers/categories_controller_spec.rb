require 'spec_helper'

describe CategoriesController do
  authorize

  let!(:category) { create :category }
  let(:default_params) { { category: { foo: 'bar' } } }

  describe "GET index" do
    it "assigns all categories as @categories" do
      get :index
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe "GET show" do
    it "assigns the requested category as @category" do
      get :show, id: category.to_param
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "GET edit" do
    it "assigns the requested category as @category" do
      get :edit, id: category.to_param
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, default_params
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, default_params
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the created category" do
        post :create, default_params
        expect(response).to redirect_to(Category.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        allow_any_instance_of(Category).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        allow_any_instance_of(Category).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested category" do
        expect_any_instance_of(Category).to receive(:update_attributes).with({ "name" => "Test" })
        put :update, id: category.to_param, category: { "name" => "Test" }
      end

      it "assigns the requested category as @category" do
        put :update, id: category.to_param, category: { "name" => "test" }
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        put :update, id: category.to_param, category: { "name" => "test" }
        expect(response).to redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        allow_any_instance_of(Category).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, id: category.to_param, category: { "name" => "invalid value" }
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        allow_any_instance_of(Category).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, id: category.to_param, category: { "name" => "invalid value" }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested category" do
      expect {
        delete :destroy, id: category.to_param
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      delete :destroy, id: category.to_param
      expect(response).to redirect_to(categories_url)
    end
  end

end
