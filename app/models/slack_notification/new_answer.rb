class SlackNotification::NewAnswer < SlackNotification
  def initialize(answer, options={})
    @answer = answer
    super(options)
  end

  private

  def attachments
    answer_path = url_for([@answer.game, @answer, { only_path: false }])
    [{
      pretext: pretext,
      title: title,
      title_link: answer_path,
      text: @answer.answer,
      color: "#337AB7",
      fallback: "#{pretext} #{answer_path}",
    }]
  end

  def pretext
    @answer.amount ? "New Imperilment clue!" : "Final Imperilment!"
  end

  def title
    title = "#{@answer.category.name}"
    title << " for $#{@answer.amount}" if @answer.amount
    title
  end
end
