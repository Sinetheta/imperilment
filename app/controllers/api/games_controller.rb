module Api
  class GamesController < BaseController
    load_resource :game

    def show
      render json: @game, root: false
    end
  end
end
