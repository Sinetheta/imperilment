class LeaderBoardsController < ApplicationController
  load_and_authorize_resource :game

  respond_to :html

  def index
    @scores = User.all.map{|u| {user: u, score: @game.score(u)}}
    @scores = @scores.sort_by{|a| -a[:score]}
    @scores = @scores.group_by{|a| a[:score]}
    respond_with @game
  end
end
