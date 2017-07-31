$(window).ready ->
  # When the form submits, pause it to get the avatar_url
  $("#new_user").submit (e) ->
    # Unbind so that when it is submitted, does not reset the avatar_url
    $(this).unbind("submit")
    e.preventDefault()
    # Try to get the google profile associated with this email
    $.ajax {
      url: "http://picasaweb.google.com/data/entry/api/user/" + $("#user_email").val() + "?alt=json"
      dataType: '*'
      success: (data) ->
        submitForm data["entry"]["gphoto$thumbnail"]["$t"]
      error: (err) ->
        submitForm()
    }

# Submit the form after filling in the hidden avatar_url input
#   with the input provided
submitForm = (avatar_url = "") ->
  $('[name="user[avatar_url]"]').val(avatar_url)
  $("#new_user").submit()

