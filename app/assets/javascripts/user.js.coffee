$ ->
  $('.admin-grant a').on 'ajax:success', ->
     $row = $(this).closest('tr')
     $row.find('.admin-grant').addClass('hide')
     $row.find('.admin-revoke').removeClass('hide')
     $row.addClass('success')

  $('.admin-revoke a').on 'ajax:success', ->
     $row = $(this).closest('tr')
     $row.find('.admin-revoke').addClass('hide')
     $row.find('.admin-grant').removeClass('hide')
     $row.removeClass('success')
