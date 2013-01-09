class LandingController < ApplicationController
  skip_authorization_check

  def show
    answer = Answer.most_recent
    if answer
      redirect_to game_answer_path(answer.game, answer)
    else
      render :show
    end
  end
end
