class Season
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def self.current
    new latest_year
  end

  def date_range
    time.beginning_of_year..time.end_of_year
  end

  def games
    Game.where(ended_at: date_range).order(:ended_at)
  end

  def game_results
    GameResult.joins(:game).merge(games)
  end

  def overall_results
    game_results.all_results
  end

  def overall_results_by_money
    game_results.all_results_by_money
  end

  private

  def self.latest_year
    Time.current.year
  end

  def time
    Time.new(@year)
  end
end
