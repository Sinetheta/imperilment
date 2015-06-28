class SlackNotification::NewAnswer < SlackNotification
  def initialize(answer, options={})
    @answer = answer
    super(options)
  end

  private

  def attachments
    answer_path = url_for([@answer.game, @answer, { only_path: false }])
    [{
      pretext: "New Imperilment clue!",
      title: "#{@answer.category.name} for $#{@answer.amount}",
      title_link: answer_path,
      text: @answer.answer,
      color: "#337AB7",
      fallback: "New Imperilment clue! #{answer_path}",
    }]
  end
end
