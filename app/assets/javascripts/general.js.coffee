$ ->
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
