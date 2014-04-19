class Imperilment.Models.Question extends Backbone.Model
  paramRoot: "question"

  url: =>
    Routes.api_game_answer_question_path @get("game_id"), @get("answer_id"), @get("id")

  game: =>
    @game = new Imperilment.Models.Game id: @get("game_id")
    @game.fetch()

  answer: =>
    @answer = new Imperilment.Models.Answer game_id: @get("game_id"), id: @get("answer_id")
    @answer.fetch()

  initialize: ->
    @answer() if @get("answer_id")? and @get("game_id")?

