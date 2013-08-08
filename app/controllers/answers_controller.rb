class AnswersController < ApplicationController
  load_and_authorize_resource :game
  load_and_authorize_resource :answer, through: :game

  respond_to :html, :json

  def index
    @answers = @answers.page(params[:page])
    respond_with @game, @answers
  end

  def show
    if @answer.amount.nil? && @answer.question_for(current_user).nil?
      redirect_to [:final, @game, @answer]
    else
      respond_with @game, @answer
    end
  end

  def final
    if @answer.question_for(current_user)
      redirect_to [@game, @answer]
    else
      if params[:wager]
        if params[:wager].to_i < 0 || params[:wager].to_i > @game.score(current_user)
          flash.alert = "Your wager must be between $0 and $#{@game.score(current_user)}"
          respond_with @game, @answer
        else
          @question = Question.new
          @question.user = current_user
          @question.amount = params[:wager]
          @question.answer = @answer
          @question.save!
          redirect_to [@game, @answer]
        end
      end

    end
  end

  def new
    respond_with @game, @answer
  end

  def edit
    respond_with @game, @answer
  end

  def create
    @answer.game_id = params.require(:game_id)
    if @answer.save
      flash.notice = t :model_create_successful, model: Answer.model_name.human
    end
    respond_with @game, @answer
  end

  def update
    if @answer.update_attributes(answer_params)
      flash.notice = t :model_update_successful, model: Answer.model_name.human
    end
    respond_with @game, @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer, location: @game
  end

  private
  def answer_params
    params.require(:answer).permit :amount, :answer, :correct_question, :start_date, :category_id
  end
end
