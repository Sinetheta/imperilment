$(window).ready ->
  # When the form submits, pause it to get the avatar_url
  $("#new_user").submit (e) ->
    # Unbind so that when it is submitted, does not reset the avatar_url
    $(this).unbind("submit")
    e.preventDefault()
    # Try to get the google profile associated with this email
    #   In this case, we want it to submit the form whether or not
    #   the user has a google profile
    getGoogleImage(
      submitForm
      submitForm)

# Submit the form after filling in the hidden avatar_url input
#   with the input provided
submitForm = (avatar_url = "") ->
  $('[name="user[avatar_url]"]').val(avatar_url)
  $("#new_user").submit()

# Set up the buttons which allow the user to
#   change their avatar type */
$(window).ready ->
  # Set all buttons to send a request on click
  $("button[data-avatar-type]").click ->
    btn = $(this)
    btn.html "<i class=\"icon-spin6\"></i>"
    btn.prop 'disabled', 'disabled'

    # Send request to change to a certain type of avatar
    switch btn.data("avatar-type")
      when "google"
        getGoogleImage(
          (url) ->
            changeAvatar btn, url
          () ->
            errAvatar btn
        )
      when "gravatar"
        getGravatarImage(
          (url) ->
            changeAvatar btn, url
          () ->
            errAvatar btn
        )
      # Icon can just immediantly contact the server because every user
      #   should be able to switch the the icon
      when "icon"
        changeAvatar btn, ""

# Change a user's avatar_url via changeAvatar and show the user
#   the change has bee successful
foundAvatar = (btn) ->
  # Show success
  btn.html "Success!"
  btn.removeClass("btn-primary")
  btn.addClass("btn-success")

# Show error when an avatar type is not found
errAvatar = (btn) ->
  # Show failure
  btn.html "Cannot find avatar type associated with email"
  btn.removeClass("btn-primary")
  btn.addClass("btn-danger")

# Get the google profile picture associated with the user's
#   email. Calls successCallback if the user has a google picture
#   and errCallback if they don't.
getGoogleImage = (successCallback, errCallback) ->
  $.ajax {
      url: "http://picasaweb.google.com/data/entry/api/user/" + $("#user_email").val() + "?alt=json"
      dataType: '*'
      success: (data) ->
        # Call success callback with the picture url as the parameter
        successCallback(data["entry"]["gphoto$thumbnail"]["$t"])
      error: (err) ->
        errCallback()
    }

# Get a gravatar image from the user's email
getGravatarImage = (successCallback, errCallback) ->
  # Create the url just once, to avoid hashing twice
  gravatar_url = "http://gravatar.com/avatar/" + md5($("#user_email").val()) + "?d=404"
  # Check if image exists
  $.ajax {
    url: gravatar_url
    type: "get"
    success: (data) ->
      successCallback gravatar_url
    error: () ->
      errCallback()
  }

# Change the current user's avatar to a certain url
changeAvatar = (btn, avatar_url) ->
    $.ajax {
      url: "/change_avatar"
      type: "post"
      data: {avatar_url: avatar_url}
      success: (data) ->
        foundAvatar btn
      error: (err) ->
        # Log the error and tell the user the attempt was unseccessful
        console.error err
        errAvatar btn
    }
