@format_local_time = ($wrapper)->
  format = $wrapper.data('momentjs-format')
  date = new Date($wrapper.text())
  $wrapper.text(date.toString(format))

###*
 * With Monday as the start of the week, we want the next Sunday
 *
 * @param {Date} selectedDate - An input date
 * @return {Date} the Sunday which follows this date (if not already Sunday)
 *###
@endOfWeek = (selectedDate)->
  date = new Date(selectedDate.getTime());
  lastday = date.getDate() + (7 - date.getDay()) % 7;
  date.setDate(lastday);
  date

$ =>
  $('[data-momentjs-format]').each (i, el) =>
    @format_local_time $(el)

  $('.weekpicker').datepicker
    'format': 'yyyy-mm-dd',
    'autoclose': true,
    weekStart: 1, # start week on Monday
    container: '#weekpicker-wrapper'
  .on 'changeDate', (e) =>
    $(e.target).datepicker('update', @endOfWeek(e.date));
