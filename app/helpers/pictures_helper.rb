module PicturesHelper
  
  # Returns the size of the specified picture in the WIDTHxHEIGHT format for 
  # consumption by the image_tag function in Rails.
  def picture_size(picture, format)
    if !picture
      nil
    elsif format == 'original'
      
      # If the requested format is original, simply return the picture's width 
      # and height
      picture.width.to_s + 'x' + picture.height.to_s
    else
      
      # If the picture is in a format other than original, find the child
      # picture of the appropriate format and use its width and height
      formatted_picture = Picture.find_by_parent_id(picture.id, :conditions => "thumbnail = '#{format}'")
      if formatted_picture
        formatted_picture.width.to_s + 'x' + formatted_picture.height.to_s
      else
        nil
      end
    end
  end
  
  # Returns alt text for a picture, taking into account that some pictures do 
  # not have a title.
  def picture_alt(picture)
    title = picture.title.blank? ? 'Picture' : picture.title
    if picture.location
      title + ' from ' + display_location(picture.location, true)
    elsif picture.post && !picture.post.title.blank?
      title + " from '#{picture.post.title}'"
    else
      title
    end
  end
end
