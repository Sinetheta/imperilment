module LeaderBoardHelper
  def rank_class(rank)
    case rank
    when 0
      "gold"
    when 1
      "silver"
    when 2
      "bronze"
    else
      ""
    end
  end
end
