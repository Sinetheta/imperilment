module LeaderBoardHelper
  def rank_class(rank)
    case rank
    when 1
      "gold"
    when 2
      "silver"
    when 3
      "bronze"
    else
      ""
    end
  end

  def breakdown_icon(result)
    case result
    when :unavailable
      "\u3164" # blank space character to prevent layout collapse
    when :unanswered
      icon 'help'
    when :unmarked
      icon 'minus'
    when :correct
      icon 'ok'
    when :incorrect
      icon 'cancel'
    when :too_soon
      icon 'hourglass-1'
    end
  end

  def status_for(answer)
    if !answer
      :unavailable
    elsif !(question = answer.question_for(current_user))
      if answer.too_soon?
        :too_soon
      else
        :unanswered
      end
    else
      question.status
    end
  end
end
