class Imperilment.Collections.Answers extends Backbone.Collection
  url: =>
    Routes.api_game_answers_path @game_id

  model: (attrs, options)=>
    new Imperilment.Models.Answer $.extend(attrs, {game_id: @game_id}), options

  initialize: (options)->
    @game_id = options.game_id

