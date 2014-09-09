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
        'autoclose': true

    $(document).on 'change', '.dropdown-nav select', ->
      window.location = $(this).find('option:selected').data('path')

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
          container.removeClass('success error')
          container.find('span.checked').fadeOut ->
            container.find('span.actions').fadeIn()
        else
          if correct
            container.addClass('success')
          else
            container.addClass('error')
          container.find('span.actions').fadeOut ->
            container.find('span.checked').fadeIn()
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
        if lock
          container.addClass('info')
          container.find('span.lock').fadeOut ->
            container.find('span.unlock').fadeIn()
        else
          container.removeClass('info')
          container.find('span.unlock').fadeOut ->
            container.find('span.lock').fadeIn()
      false
) ($window ? window)
