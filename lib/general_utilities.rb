module GeneralUtilities
  # Creates URL for post that includes country and location, where present  
  def verbose_post_path(post, include_host = false)
    location = post.locations ? post.locations.first : nil
    if location and location.country
      country = location.country
      show_post_long_url(:country_code => country.code,
        :country_name => country.name.gsub(/\s/, '-').gsub(/\./, ''),
        :location_id => location.id,
        :location_name => location.name.gsub(/\s/, '-').gsub(/\./, ''),
        :id => post.id,
        :host => include_host ? $DEFAULT_HOST : nil)
    elsif location
      show_post_medium_url(:location_id => location.id,
        :location_name => location.name.gsub(/\s/, '-').gsub(/\./, ''),
        :id => post.id,
        :host => include_host ? $DEFAULT_HOST : nil)
    else
      show_post_short_url(:id => post.id,
        :host => include_host ? $DEFAULT_HOST : nil)
    end
  end
  
  # Smart concatenation of arrays
  def smush(*things)
    array = []
    things.each do |thing|
      if !thing.nil?
        if thing.class == Array
          array += thing
        else
          array.push thing
        end
      end
    end
    return array
  end
  
  # Chunk up array into an array of arrays of n length
  def chunk(array, length)
    chunky_array = []
    loop do
      if array.length <= length
        chunky_array.push array
        break
      else
        chunky_array.push array.slice!(0..length - 1)
      end
    end
    return chunky_array
  end
  
  # Derives age from a given birth date
  def birth_date_to_age(birth_date)   
    age = Date.today.year - birth_date.year  
    if Date.today.month < birth_date.month || (Date.today.month == birth_date.month && birth_date.day >= Date.today.day)  
      age = age - 1  
    end
    age.to_s
  end
  
  # Where statement that filters out posts that have no title, content or pictures
  def empty_post_filter
    "(posts.id not in (select id from posts
      where (title is null
      or title = \"\")
      and (content is null
      or content = \"\")
      and id not in (select post_id from pictures where post_id is not null)))"
  end
  
  #  def self.included(base)
  #    base.send :helper_method, 
  #      :verbose_post_path, 
  #      :birth_date_to_age
  #  end
end