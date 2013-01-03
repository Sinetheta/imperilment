$ ->
  $(document).on 'focus', 'input.datepicker', ->
    $(this).datepicker
      'format': 'yyyy-mm-dd',
      'autoclose': true
