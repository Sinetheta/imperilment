$ ->
  $('span[class*="admin"] a').on 'ajax:success', ->
    $(this).closest('span[class*="admin"]').fadeOut ->
      $(this).siblings('span[class*="admin"]').fadeIn()

  $('span.admin-grant a').on 'ajax:success', ->
     $row = $(this).closest('tr');
     $row.insertAfter( $row.siblings('tr.success').last() );
     $row.addClass('success');

  $('span.admin-revoke a').on 'ajax:success', ->
     $row = $(this).closest('tr');
     $row.insertAfter( $row.siblings('tr').last() );
     $row.removeClass('success');
