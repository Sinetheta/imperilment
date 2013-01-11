class LeaderBoardsController < ApplicationController
  before_filter :load_most_recent_game, except: [:index]

  load_and_authorize_resource :game

  respond_to :html

  def index
    @games = Game.locked
    @users = User.with_overall_score
    respond_with @users, @games
  end

  def show
    @users = User.grouped_and_sorted_by_score(@game)
    respond_with @users, @game
  end

  protected
  def load_most_recent_game
    unless params[:game_id]
      @game = Game.order(:created_at).reverse_order.first
    end
  end
end
