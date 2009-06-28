module ProfilePicturesHelper
  
  # Returns an image tag for the profile picture of the specified user, in
  # the specified format (size).
  #
  # Takes into account that not all users have uploaded a profile pic.
  def profile_pic_tag(user, format)
    
    # If the user has uploaded a profile pic, use that
    # Otherwise, use the blank profile pic image
    # Images link to the user's profile page
    if user.profile_picture      
      link_to image_tag(user.profile_picture.public_filename(format.to_sym), 
        :size => profile_pic_size(user, format), 
        :alt => user.login), 
        user_profile_url(:user_login => user.login), 
        :title => user.login,
        :class => 'image-link'
    else
      link_to image_tag(blank_profile_pic_url(format), 
        :size => blank_profile_pic_size(format), 
        :alt => user.login), 
        user_profile_url(:user_login => user.login), 
        :title => user.login, 
        :class => 'image-link'
    end
  end
  
  # Returns the size of the specified user's profile picture in the WIDTHxHEIGHT 
  # format for consumption by the image_tag function in Rails.
  def profile_pic_size(user, format)
    
    # Get original profile picture for user
    picture = ProfilePicture.find_by_user_id(user.id)
    
    if !picture
      nil
    elsif format == 'original'
      
      # If the requested format is original, simply return the picture's width 
      # and height
      picture.width.to_s + 'x' + picture.height.to_s
    else
      
      # If the picture is in a format other than original, find the child
      # picture of the appropriate format and use its width and height
      formatted_picture = ProfilePicture.find_by_parent_id(picture.id, :conditions => "thumbnail = '#{format}'")
      if formatted_picture
        formatted_picture.width.to_s + 'x' + formatted_picture.height.to_s
      else
        nil
      end
    end
  end
  
  # Returns the size of the blank profile picture in the WIDTHxHEIGHT 
  # format, based on the specified format.
  def blank_profile_pic_size(format)
    if format == 'display'
      '200x200'
    elsif format == 'tiny'
      '100x100'
    elsif format == 'xtiny'
      '50x50'
    else
      nil
    end
  end
  
  # Returns the URL of the blank profile picture of the specified format.
  def blank_profile_pic_url(format = 'tiny')
    "/images/profile_pictures/profile_blank_#{format}.png"
  end
end
