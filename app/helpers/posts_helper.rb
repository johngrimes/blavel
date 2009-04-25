module PostsHelper
  
  # Applies a set of rules for sanitizing textual content before display.
  #
  # The completely flag strips all tags from the content.
  def sanitized(content, completely = false)
    if !completely
      
      # Remove all tags except those in the allowed list
      sanitize content, :tags => %w(strong em strike ul ol li a br p)
    else
      
      # Put a space after paragraphs, line breaks and list items so that there
      # will be spaces between these items after all tags have been stripped
      content = content ? content.gsub('</p>', '</p> ').gsub('<br>', '<br> ').gsub('</li>', '</li> ') : nil
      
      # Strip all tags from the content
      sanitize content, :tags => %w()
    end
  end
  
  # Generates a location summary for a post, taking into account that a post
  # can be tagged with any number of locations.
  def post_location_summary(post, omit_links = false, include_host = false)
    if post.locations.length > 1
      
      # Create array of distinct countries for post locations
      countries = []
      for location in post.locations
        if omit_links
          country_name = location.country.name
        else
          country_name = link_to(location.country.name.gsub(/\s/, '&#160;'), 
            browse_country_url(:continent_code => location.country.continent.code, 
              :continent_name => location.country.continent.name.gsub(/\s/, '-'), 
              :country_code => location.country.code, 
              :country_name => location.country.name.gsub(/\s/, '-'),
              :host => include_host ? $DEFAULT_HOST : nil))
        end
        if !countries.include?(country_name)
          countries << country_name
        end
      end
      
      # Display appropriate summary based on number of distinct countries
      if countries.length == 1
        location_summary = "locations in #{countries[0]}" 
      elsif countries.length == 2
        location_summary = "locations in #{countries[0]} and #{countries[1]}"  
      else
        location_summary = "locations in #{countries[0]}, #{countries[1]}..."
      end
    else
      location_summary = "location: #{display_location(post.locations[0], omit_links, include_host)}"
    end
  end
  
  # Returns a link to the specified post, taking into account that the post
  # may not have a title.
  #
  # The from flag puts a from before the link, as used in the case of a picture.
  def post_link(post, from = false)
    if post.title.blank? && !from
      
      # untitled post (from = false)
      link_to 'untitled post', verbose_post_path(post)
    elsif post.title.blank? && from
      
      # from an untitled post (from = true)
      'from an ' + link_to('untitled post', verbose_post_path(post))
    elsif !post.title.blank? && !from
      
      # 'post title' (from = false)
      link_to post.title, verbose_post_path(post)
    else
      
      # from 'post title' (from = true)
      'from ' + link_to(post.title, verbose_post_path(post))
    end
  end
  
  # Constructs a textual summary of a post for use on a feed.
  def post_feed_summary(post, include_host = false)
    
    # Create a link for the name of the note leaver, using you if the poster is 
    # the user currently logged in
    poster_link = link_to(post.user.login, user_profile_url(:user_login => post.user.login, :host => include_host ? $DEFAULT_HOST : nil))
    
    # Get the verbose url for the post
    post_url = verbose_post_path(post, true)
    
    # If the post has pictures and no content or title, summarise it as 
    # x posted some new pictures
    # Otherwise, summarise as x wrote a new post
    if (post.pictures && !post.pictures.empty?) && post.content.blank? && post.title.blank?
      
      # Take into account one picture versus plural pictures
      if post.pictures.length > 1
        subject = 'posted some new ' + link_to('pictures', post_url)
      else
        subject = 'posted a new ' + link_to('picture', post_url)
      end
    else
      
      # Take into account posts without titles
      if post.title.blank?
        subject = 'wrote a new ' + link_to('post', post_url)
      else
        subject = 'wrote a new post called ' + link_to(post.title, post_url)
      end
    end
    
    # String the sentence together and return
    poster_link + ' ' + subject + '.'
  end
end
