class Season
  attr_reader :year

  def initialize year
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

  private
  def self.latest_year
    if game = Game.order(:ended_at).last
      game.ended_at.year
    else
      Time.current.year
    end
  end

  def time
    Time.new(@year)
  end
end
