class CategoriesController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @categories = @categories.page(params[:page])
    respond_with @categories
  end

  def show
    respond_with @category
  end

  def new
    respond_with @category
  end

  def edit
    respond_with @category
  end

  def create
    if @category.save
      flash.notice = t :model_create_successful, model: Category.model_name.human
    end
    respond_with @category
  end

  def update
    if @category.update_attributes(category_params)
      flash.notice = t :model_update_successful, model: Category.model_name.human
    end
    respond_with @category
  end

  def destroy
    @category.destroy
    respond_with @category, location: categories_path
  end

  private

  def category_params
    params.require(:category).permit :name
  end
end
