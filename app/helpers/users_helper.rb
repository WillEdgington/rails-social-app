module UsersHelper
  def profile_image_for(user, size: 50)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]),
                alt: "#{user.username}'s profile photo",
                class: "profile-image"
    else
      image_tag "default_profile.png",
                alt: "Default profile photo",
                class: "profile-image",
                size: "#{size}x#{size}"
    end
  end
end
