class LeaderBoardsController < ApplicationController
  before_filter :set_season
  before_filter :load_games

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
    game_scope = @games.includes(:answers => :questions)
    if params[:game_id]
      @game = game_scope.find(params[:game_id])
    else
      @game = game_scope.last
    end

    if @game
      @results = @game.build_results
      respond_with(@results, include: :user, methods: :results)
    else
      render 'no_games'
    end
  end

  protected

  def set_season
    @season =
      if params[:season]
        Season.new(params[:season].to_i)
      else
        Season.current
      end
  end

  def load_games
    @games ||= @season.games
  end
end
