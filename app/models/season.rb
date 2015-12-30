class Season
  attr_reader :year

  def initialize(year)
    @year = year
  end

  def self.current
    new latest_year
  end

  def start_date
    Date.commercial(@year, 1).beginning_of_day
  end

  def end_date
    (Date.commercial(@year + 1, 1) - 1.day).end_of_day
  end

  def date_range
    start_date..end_date
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
    Time.current.to_date.cwyear
  end

end
