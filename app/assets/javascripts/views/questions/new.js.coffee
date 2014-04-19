class Imperilment.Views.QuestionsNew extends Backbone.View
  template: "#new-question-template"

  render: ->
    @$el.html _.template($(@template).html(), { question: @model.toJSON() })
    @

