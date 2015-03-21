class AnswersController < ApplicationController
  before_filter :load_game
  authorize_resource :game
  load_and_authorize_resource :answer, through: :game

  respond_to :html

  def index
    @answers = @answers.page(params[:page])
    respond_with @game, @answers
  end

  def show
    if @answer.final? && @answer.question_for(current_user).nil?
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
        @question = @answer.questions.new do |q|
          q.user = current_user
          q.amount = params[:wager]
        end
        if @question.save
          redirect_to [@game, @answer]
        else
          respond_with @game, @answer
        end
      end

    end
  end

  def new
    @answer.category = Category.last
    respond_with @game, @answer
  end

  def edit
    respond_with @game, @answer
  end

  def create
    @answer.game = @game
    if @answer.save
      flash.notice = t :model_create_successful, model: Answer.model_name.human
      event = WebHook::Event::NewAnswer.new(@answer)
      WebHook::Dispatch.new(event, WebHook.all).deliver
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
  def load_game
    @game = Game.includes(:answers => :questions).find(params[:game_id])
  end
  def answer_params
    params.require(:answer).permit :amount, :answer, :correct_question, :start_date, :category_id
  end
end
