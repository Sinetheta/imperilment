module AvatarHelper

 # Get an image tag if the user has an avatar, or
 #   an icon if the user does not
  def avatar_for(user)
    if user.avatar_url.nil?
      icon :user
    else
      # Alt is blank so that if the url does not work,
      #   nothing will be displayed
      image_tag user.avatar_url, alt: ""
    end
  end
end
