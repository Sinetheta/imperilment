module Scoring
  # A class to hold the outcome of a game.
  # This is an alternative to the GameResult to allow for more customizable leaderboards.
  class PlayerRow
    attr_reader :user, :results, :total, :position

    def self.from_result(game_result)
      answers = game_result.game.all_answers
      points = game_result.results.zip(answers).map do |status, answer|
        Point.new(answer: answer, status: status, value: 0)
      end
      new(
        user: game_result.user,
        points: points,
        total: game_result.total,
        position: game_result.position
      )
    end

    def initialize(
      user:,
      points:,
      total: nil,
      position: nil
    )
      @user = user
      @points = points
      @total = total
      @position = position
    end
  end
end
