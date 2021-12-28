#= require select2

((window) ->
  $ ->
    $('select')
    # bootstrap styles added by simple form are bad for the <select>
    .removeClass('form-control')
    # but we still need to style "inside" of the generated label+input pair
    .wrapAll('<div />')
    .select2()

    $(document).on 'focus', 'input.datepicker', ->
      $(this).datepicker
        'format': 'yyyy-mm-dd',
        'autoclose': true,
        weekStart: 1, # start week on Monday

    $(document).on 'click', 'a[data-correct]', ->
      container = $(this).parents('tr')
      correct = $(this).data('correct')

      request = $.ajax
        url: $(this).attr('href')
        type: 'PUT'
        dataType: 'JSON'
        data: "question[correct]=#{correct}"
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}

      request.done (msg)->
        if correct is null
          container.removeClass('success danger')
          container.find('span.checked, span.actions').toggleClass('show hide')
        else
          if correct
            container.addClass('success')
          else
            container.addClass('danger')
          container.find('span.actions, span.checked').toggleClass('show hide')
      false

    $(document).on 'click', 'a[data-lock]', ->
      container = $(this).parents('tr')
      lock = $(this).data('lock')

      request = $.ajax
        url: $(this).attr('href')
        type: 'PUT'
        dataType: 'JSON'
        data: "game[locked]=#{lock}"
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}

      request.done (msg)->
        container.find('.lock, .unlock').toggleClass('show hide')
        container.toggleClass('info')
      false
) ($window ? window)
