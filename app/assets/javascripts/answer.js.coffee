@answer_value = ($amount)->
  day_of_week = $amount?.getDay()
  weekday_value = switch day_of_week
    when 1 then 200
    when 2 then 600
    when 3 then 1000
    when 4 then 400
    when 5 then 1200
    when 6 then 2000
    else ''

@current_date = ($datepicker) ->
  if !!$datepicker.val()
    $datepicker.data('datepicker').getDate()

@update_answer_amount = ($datepicker, $amount)->
  value = answer_value(current_date $datepicker)
  $amount.val value

@init_datepicker = ($datepicker, $amount)->
    $('#answer_start_date').datepicker
      'format': 'yyyy-mm-dd',
      'autoclose': true,
      'update'
    update_answer_amount $datepicker, $amount

$ ->
  $datepicker = $('#answer_start_date')
  $amount = $('#answer_amount')

  init_datepicker $datepicker, $amount

  $datepicker.on 'changeDate', (event) ->
    $amount.val(answer_value(event.date))
