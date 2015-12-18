class SlackNotification::GameFinalization < SlackNotification
  def initialize(game, options={})
    @game = game
    super(options)
  end

  private

  def attachments
    [{
      pretext: "Imperilment results are in!",
      title: "This week's winners",
      title_link: leader_board_url(@game.id),
      text: podium_text,
      color: "#337AB7",
      fallback: "This week's winners are in! #{leader_board_url(@game.id)}",
    }]
  end

  def medalists
    @game.game_results.group_by(&:position)
  end

  def podium_text
    [[1, ':trophy:'], [2,':silver:'], [3, ':bronze:']].map do |(place, emoji)|
      (medalists[place] || []).map do |game_result|
        "#{emoji} $#{game_result.total} #{game_result.user.identifier}"
      end
    end.flatten.join("\n\n")
  end
end
