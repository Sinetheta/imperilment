class SlackNotification::NewAnswer < SlackNotification
  def initialize(answer, options={})
    @answer = answer
    super(options)
  end

  private

  def attachments
    [{
      pretext: pretext,
      title: title,
      title_link: game_answer_url(@answer.game, @answer),
      text: text,
      color: "#337AB7",
      fallback: "#{pretext} #{game_answer_url(@answer.game, @answer)}",
      mrkdwn_in: %w(text),
    }]
  end

  def pretext
    @answer.amount ? "New Imperilment clue!" : "Final Imperilment!"
  end
  
  def text
    @answer.amount ? @answer.answer : ""
  end

  def title
    title = "#{@answer.category.name}"
    title << " for $#{@answer.amount}" if @answer.amount
    title
  end
end
