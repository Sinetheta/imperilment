#= require spec_helper
#= require general

describe 'general', ->
  describe 'dropdown-nav', ->
    beforeEach ->
      $('body').html(JST['templates/dropdown-nav']())

    context 'when the select box is changed', ->
      it 'redirects to the data path of the selected option', ->
        $('select').val($('option').last().val())
        $('select').change()
        $window.location.should.equal '/path-2'
