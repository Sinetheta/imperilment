require 'spec_helper'

describe CategoriesController do
  authorize

  let!(:category) { create :category }

  describe "GET index" do
    it "assigns all categories as @categories" do
      get :index
      assigns(:categories).should eq([category])
    end
  end

  describe "GET show" do
    it "assigns the requested category as @category" do
      get :show, id: category.to_param
      assigns(:category).should eq(category)
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new
      assigns(:category).should be_a_new(Category)
    end
  end

  describe "GET edit" do
    it "assigns the requested category as @category" do
      get :edit, id: category.to_param
      assigns(:category).should eq(category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, category: {}
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create
        assigns(:category).should be_a(Category)
        assigns(:category).should be_persisted
      end

      it "redirects to the created category" do
        post :create
        response.should redirect_to(Category.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        Category.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create
        assigns(:category).should be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        Category.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested category" do
        Category.any_instance.should_receive(:update_attributes).with({ "name" => "Test" })
        put :update, id: category.to_param, category: { "name" => "Test" }
      end

      it "assigns the requested category as @category" do
        put :update, id: category.to_param
        assigns(:category).should eq(category)
      end

      it "redirects to the category" do
        put :update, id: category.to_param
        response.should redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        Category.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: category.to_param, category: { "name" => "invalid value" }
        assigns(:category).should eq(category)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Category.any_instance.stub(:save).and_return(false)
        Category.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: category.to_param, category: { "name" => "invalid value" }
        response.should render_template("edit")
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
      response.should redirect_to(categories_url)
    end
  end

end
