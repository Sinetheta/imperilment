class LeaderBoardsController < ApplicationController
  before_filter :load_most_recent_game, except: [:index]

  authorize_resource :game

  respond_to :html, :json

  def index
    @results = GameResult.all_results
    respond_with(@results, include: :user)
  end

  def show
    if @game
      @results = @game.build_results
      respond_with(@results, include: :user, methods: :results)
    else
      render 'no_games'
    end
  end

  def money
    @results = GameResult.all_results_by_money
    respond_with(@results, include: :user)
  end

  protected

  def load_most_recent_game
    if params[:game_id]
      @game = Game.find(params[:game_id])
    else
      @game = Game.order(:created_at).reverse_order.first
    end
  end
end
