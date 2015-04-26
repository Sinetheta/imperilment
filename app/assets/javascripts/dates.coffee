@format_local_time = ($wrapper)->
  format = $wrapper.data('momentjs-format')
  date = new Date($wrapper.text())
  $wrapper.text(date.toString(format))

$ =>
  $('[data-momentjs-format]').each (i, el) =>
    @format_local_time $(el)
