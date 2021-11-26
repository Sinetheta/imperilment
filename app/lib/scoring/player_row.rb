module Scoring
  # A class to hold the outcome of a game.
  # This is an alternative to the GameResult to allow for more customizable leaderboards.
  class PlayerRow
    attr_reader :user, :results, :total, :position

    def self.from_result(game_result)
      new(
        user: game_result.user,
        results: game_result.results,
        total: game_result.total,
        position: game_result.position,
      )
    end

    def initialize(
      user:,
      results: nil,
      total: nil,
      position: nil
    )
      @user = user
      @results = results
      @total = total
      @position = position
    end
  end
end
