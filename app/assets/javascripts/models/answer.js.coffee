class Imperilment.Models.Answer extends Backbone.Model
  paramRoot: "answer"

  url: =>
    Routes.api_game_answer_path @get("game_id"), @get("id")

  game: =>
    @game = new Imperilment.Models.Game id: @get("game_id")
    @game.fetch()

  initialize: ->
    @game() if @get("game_id")?

