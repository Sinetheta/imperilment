module ApplicationHelper
  def app_name
    "Imperilment!"
  end

  def format_date(date)
    if date.nil?
      ""
    else
      l date, format: :short
    end
  end
  alias d format_date
end
