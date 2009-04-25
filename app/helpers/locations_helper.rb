module LocationsHelper
  
  # Constructs a summary of a location's name and country for display.
  def display_location(location, omit_links = false, include_host = false)
    country = location.country
    
    # Check whether country is present for this location
    if (country)

      # If omit_links flag is set, return a string without any hyperlinks in it
      unless omit_links
        
        # If country is present, get urls for country and location that are
        # verbose, i.e. the country and continent names are included in the url
        country_link = link_to(country.name.gsub(/\s/, '&#160;'), 
          browse_country_url(:continent_code => location.country.continent.code, 
            :continent_name => location.country.continent.name.gsub(/\s/, '-'), 
            :country_code => location.country.code, 
            :country_name => location.country.name.gsub(/\s/, '-'),
            :host => include_host ? $DEFAULT_HOST : nil))
        location_link = link_to(truncate(location.name.gsub(/\s/, '&#160;'), 40), 
          browse_location_url(:continent_code => location.country.continent.code, 
            :continent_name => location.country.continent.name.gsub(/\s/, '-'), 
            :country_code => location.country.code, 
            :country_name => location.country.name.gsub(/\s/, '-'), 
            :location_id => location.id, 
            :location_name => location.name.gsub(/\s/, '-'),
            :host => include_host ? $DEFAULT_HOST : nil))
        
        # Return location link, country link
        "#{location_link}, #{country_link}"
      else
        
        # Return location name, country name with no links
        "#{location.name}, #{country.name}"
      end
    else
      
      # If omit_links flag is set, return a string without any hyperlinks in it
      unless omit_links
       
        # If no country is present for this location, use a url without
        # continent and country names in it
        location_link = link_to(truncate(location.name.gsub(/\s/, '&#160;'), 40), 
          browse_location_no_country_url(:location_id => location.id, 
            :location_name => location.name.gsub(/\s/, '-'),
            :host => include_host ? $DEFAULT_HOST : nil))
      
        # Return location link
        location_link
      else
        
        # Return location name with no link
        location.name
      end
    end
  end
  
  # Constructs an map image tag for any number of post and/or picture locations,
  # using the Google Static Maps API.
  # 
  # The place tag controls whether the marker is a small yellow place marker, or
  # a medium sized red marker.
  # 
  # The country flag controls the zoom level, zooming the map out to a level 
  # more suitable for showing where a country is. The country flag also stops
  # a link to a bigger map from being added to the map image.
  def map_image_tag(post_locations, picture_locations, width, height, place = false, country = false)
    
    # Initialise strings
    markers = 'markers='
    center = ''
    post_location_ids = ''
    picture_location_ids = ''
    
    if post_locations
      
      # Add marker declarations to the markers string for each post location
      # Post markers are red, unless the place flag is set
      post_locations.each do |l|
        if l
          if place
            markers += "#{l.latitude},#{l.longitude},smallyellow|"
          else
            markers += "#{l.latitude},#{l.longitude},midred|"
          end
          
          # Set the center every time, so it ends up being centered on the
          # last marker
          center = "center=#{l.latitude},#{l.longitude}"
          
          # Collect the ids of each locations for use when constructing
          # the link to view a bigger map
          post_location_ids << "#{l.id},"
        end
      end
    end
    
    # Add marker declarations to the markers string for each picture location
    # Picture markers are white
    if picture_locations
      picture_locations.each do |l|
        if l
          markers += "#{l.latitude},#{l.longitude},midwhite|"
          
          # Set the center every time, so it ends up being centered on the
          # last marker
          center = "center=#{l.latitude},#{l.longitude}"
          
          # Collect the ids of each locations for use when constructing
          # the link to view a bigger map
          picture_location_ids << "#{l.id},"
        end
      end
    end
    
    # Trim the last comma off the comma-delimited strings
    markers = markers[0..-2]
    post_location_ids = post_location_ids[0..-2]
    picture_location_ids = picture_location_ids[0..-2]
    
    # Start map string with declarations for markers, size and api key
    url = "http://maps.google.com/staticmap?#{markers}&size=#{width}x#{height}&key=#{$GOOGLE_MAPS_API_KEY}"
    
    # If the country flag is set, do not add a link to the map image
    # If there is only one marker on the map, set a zoom level of 10
    # If there is more than one marker, let the map set its own zoom level
    if (post_locations.length + picture_locations.length == 1 and country)
      url += "&#{center}&zoom=1"
      return "<img src=\"#{url}\" width=\"#{width}\" height=\"#{height}\" alt=\"Map of tagged locations!\" class=\"map\"/>"
    elsif (post_locations.length + picture_locations.length == 1)
      url += "&#{center}&zoom=10"
      return "<a class=\"map-link\" href=\"/map/#{post_location_ids}/#{picture_location_ids}\" rel=\"shadowbox;player=iframe\"><img src=\"#{url}\" width=\"#{width}\" height=\"#{height}\" alt=\"Map of tagged locations!\" class=\"map\"/></a>"
    elsif (post_locations.length + picture_locations.length > 1)
      return "<a class=\"map-link\" href=\"/map/#{post_location_ids}/#{picture_location_ids}\" rel=\"shadowbox;player=iframe\"><img src=\"#{url}\" width=\"#{width}\" height=\"#{height}\" alt=\"Map of tagged locations!\" class=\"map\"/></a>"
    else
      return ''
    end
  end
end