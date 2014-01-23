class LeaderBoardsController < ApplicationController
  before_filter :load_most_recent_game, except: [:index]

  authorize_resource :game

  respond_to :html, :json

  def index
    @results = GameResult.all_results
    respond_with(@results)
  end

  def show
    if @game
      @users = @game.grouped_and_sorted_by_score
    end
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
