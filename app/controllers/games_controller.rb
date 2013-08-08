class GamesController < ApplicationController
  load_and_authorize_resource

  respond_to :html, :json

  def index
    @games = @games.page(params[:page]).order('ended_at DESC')
    respond_with @games
  end

  def show
    respond_with @game
  end

  def new
    respond_with @game
  end

  def edit
    respond_with @game
  end

  def create
    if @game.save
      flash.notice = t :model_create_successful, model: Game.model_name.human
    end
    respond_with @game
  end

  def update
    if @game.update_attributes(game_params)
      flash.notice = t :model_update_successful, model: Game.model_name.human if request.format == :html
    end
    respond_with @game
  end

  def destroy
    @game.destroy
    respond_with @game, location: games_path
  end

  private
  def game_params
    params.require("game").permit :ended_at, :locked
  end
end
