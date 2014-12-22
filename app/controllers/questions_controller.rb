class QuestionsController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :answer, through: :game
  load_and_authorize_resource :question, through: :answer

  respond_to :html, :json

  def index
    if current_user && !current_user.has_role?(:admin)
      question = @answer.question_for(current_user)
      if question.nil? || !question.checked?
        @questions = @questions.none
      end
    end

    @questions = @questions.page(params[:page])
    respond_with @game, @answer, @questions
  end

  def show
    respond_with @game, @answer, @question
  end

  def new
    respond_with @game, @answer, @question
  end

  def edit
    respond_with @game, @answer, @question
  end

  def create
    # Can't set your answer to correct unless you're an admin.
    params[:question].except(:correct) unless current_user.has_role?(:admin)

    @question.user = current_user

    if @question.save
      flash.notice = t :model_create_successful, model: Question.model_name.human
    end
    respond_with @game, @answer, @question, location: root_path
  end

  def update
    qp = question_params
    qp[:correct] = nil if qp[:correct] == 'null'
    if @question.update_attributes(qp)
      flash.notice = t :model_update_successful, model: Question.model_name.human if request.format == :html
    end
    respond_with @game, @answer, @question, location: root_path
  end

  def destroy
    @question.destroy
    respond_with @question, location: [@game, @answer]
  end

  private
  def permitted_question_params
    if can? :correct, @question
      [:response, :correct]
    else
      [:response]
    end
  end

  def question_params
    params.require(:question).permit(*permitted_question_params)
  end
end
