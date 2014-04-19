class Imperilment.Models.Game extends Backbone.Model
  paramRoot: "game"

  url: =>
    Routes.api_game_path @get("id")

