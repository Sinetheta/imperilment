#= require spec_helper
#= require date
#= require bootstrap-datepicker
#= require answer

$datepicker = ->
  $('#answer_start_date')
$amount = ->
  $('#answer_amount')

set_up_datepicker = ->
  $('body').html(JST['templates/datepicker']({
    datepicker_id: 'answer_start_date',
    amount_id: 'answer_amount',
    value: '2013-05-13'
  }))

  $datepicker().datepicker
    'format': 'yyyy-mm-dd',
    'autoclose': true,
    'update'

describe 'answer', ->
  describe '.answer_value', ->
    mon = new Date(2013, 4, 13)
    tue = new Date(2013, 4, 14)
    wed = new Date(2013, 4, 15)
    thu = new Date(2013, 4, 16)
    fri = new Date(2013, 4, 17)
    sat = new Date(2013, 4, 18)
    sun = new Date(2013, 4, 19)

    it 'should return 200 when the date is a Monday', ->
      answer_value(mon).should.equal(200)

    it 'should return 600 when the date is a Tuesday', ->
      answer_value(tue).should.equal(600)

    it 'should return 1000 when the date is a Wednesday', ->
      answer_value(wed).should.equal(1000)

    it 'should return 400 when the date is a Thrusday', ->
      answer_value(thu).should.equal(400)

    it 'should return 1200 when the date is a Friday', ->
      answer_value(fri).should.equal(1200)

    it 'should return 2000 when the date is a Saturday', ->
      answer_value(sat).should.equal(2000)

    it 'should return an empty string when the date is a Sunday', ->
      answer_value(sun).should.equal('')

  describe '.current_date', ->
    beforeEach ->
      set_up_datepicker()

    context 'when the datepicker has text', ->
      it 'should return the correct date', ->
        value = current_date($datepicker())
        date = new Date(2013,4,13)
        Date.equals(value, date).should.be.true

    context 'when it has no text', ->
      beforeEach ->
        $datepicker().val('')

      it 'should return null', ->
        date = current_date $datepicker()
        expect(date).to.be null

  describe '.update_answer_amount', ->
    beforeEach ->
      set_up_datepicker()

    context 'when the datepicker has a date', ->
      it 'should update the value of the amount textbox', ->
        update_answer_amount($datepicker(), $amount())

        $amount().val().should.equal('200')

    context 'when the datepicker does not have a date', ->
      beforeEach ->
        $datepicker().val('')

      it 'should not update the value', ->
        update_answer_amount($datepicker(), $amount())

        $amount().val().should.equal('')

  describe '.init_datepicker', ->
    beforeEach ->
      set_up_datepicker()

    context 'when editing an answer', ->
      it 'should not change the value', ->
        init_datepicker($datepicker(), $amount())
        $amount().val().should.equal('')


    context 'when creating an answer', ->
      it 'should fill the value', ->
        $amount().data('new', 'true')
        init_datepicker($datepicker(), $amount())
        $amount().val().should.equal('200')
