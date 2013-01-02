class LandingController < ApplicationController
  skip_authorization_check

  def show
    answer = Answer.most_recent
    redirect_to game_answer_path(answer.game, answer)
  end
end
