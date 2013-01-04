class LeaderBoardsController < ApplicationController
  load_and_authorize_resource :game

  respond_to :html, :json

  def index
    @scores = User.all.collect{|u| {user: u, score: @game.score(u)}}.sort_by{|h| -h[:score]}
    respond_with @game, @scores
  end
end
