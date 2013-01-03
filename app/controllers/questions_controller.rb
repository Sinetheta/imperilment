class QuestionsController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :answer, through: :game
  load_and_authorize_resource :question, through: :answer

  respond_to :html, :json

  def index
    @questions = @questions.page(params[:page])
    respond_with @game, @answer, @questions
  end

  def show
    respond_with @game, @answer, @question
  end

  def new
    raise "Can't create second question" if @answer.question_for(current_user)
    respond_with @game, @answer, @question
  end

  def edit
    respond_with @game, @answer, @question
  end

  def create
    @question.user = current_user

    if @question.save
      flash.notice = t :model_create_successful, model: Question.model_name.human
    end
    respond_with @game, @answer, @question
  end

  def update
    if @question.update_attributes(params[:question])
      flash.notice = t :model_update_successful, model: Question.model_name.human
    end
    respond_with @game, @answer, @question
  end

  def destroy
    @question.destroy
    respond_with @question, location: [@game, @answer]
  end
end
