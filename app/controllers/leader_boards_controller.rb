class LeaderBoardsController < ApplicationController
  before_action :set_season, only: [:index, :money]
  before_action :set_game, only: [:show]

  authorize_resource :game

  respond_to :html, :json

  def index
    @results = @season.overall_results
    respond_with(@results)
  end

  def money
    @results = @season.overall_results_by_money
    respond_with(@results)
  end

  def show
    if @game
      @results = @game.locked? ?
        Scoring::LeaderBoard.from_game(@game) :
        Scoring::LeaderBoard.from_my_game(@game, current_user)
      respond_with(@results, include: :user, methods: :results)
    else
      render 'no_games'
    end
  end

  protected


  def set_game
    game_scope = Game.includes(answers: :questions)
    if params[:game_id]
      @game = game_scope.find(params[:game_id])
    else
      @game = game_scope.last
    end
  end

  def set_season
    @season =
      if params[:season]
        Season.new(params[:season].to_i)
      else
        Season.current
      end
  end
end
