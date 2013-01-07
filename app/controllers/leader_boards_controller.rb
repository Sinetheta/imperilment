class LeaderBoardsController < ApplicationController
  before_filter :load_most_recent_game

  load_and_authorize_resource :game

  respond_to :html

  def index
    @scores = User.all.map{|u| {user: u, score: @game.score(u)}}
    @scores = @scores.sort_by{|a| -a[:score]}
    @scores = @scores.group_by{|a| a[:score]}
    respond_with @game
  end

  protected
  def load_most_recent_game
    unless params[:game_id]
      @game = Game.order(:created_at).reverse_order.first
    end
  end
end
