module Scoring
  module LeaderBoard
    def self.from_game(game)
      inject_last_weeks_users(game.build_results, game).
        map(&PlayerRow.method(:from_result))
    end

    private

    def self.inject_last_weeks_users(game_results, game)
      return game_results unless game.prev

      game_results + (game.prev.users.uniq - game_results.map(&:user)).map do |user|
        GameResult.new(user: user,
          game: game,
          total: 0,
          position: (game_results.map(&:position).max || 1) + 1)
      end
    end
  end
end
