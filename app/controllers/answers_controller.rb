class AnswersController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :answer, through: :game

  respond_to :html, :json

  def index
    @answers = @answers.page(params[:page])
    respond_with @game, @answers
  end

  def show
    respond_with @game, @answer
  end

  def new
    respond_with @game, @answer
  end

  def edit
    respond_with @game, @answer
  end

  def create
    if @answer.save
      flash.notice = t :model_create_successful, model: Answer.model_name.human
    end
    respond_with @game, @answer
  end

  def update
    if @answer.update_attributes(params[:answer])
      flash.notice = t :model_update_successful, model: Answer.model_name.human
    end
    respond_with @game, @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer, location: @game
  end
end
