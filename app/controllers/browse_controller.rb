class BrowseController < ApplicationController
  layout 'standard'
  
  # Responds with:
  # * a list of all posts
  # * a selection of random pictures
  # * a list of continents to browse
  # Parameters:: page
  # Route:: GET /browse
  def index
    # Pass through all continents ordered by name
    @continents = Continent.find(:all, :order => 'name')
    
    # Pass through non-empty posts in reverse chronological order
    @posts = Post.paginate(:all, 
      :page => params[:page], :per_page => 5,
      :conditions => empty_post_filter,
      :order => 'created_at DESC')
    
    # Pass through 6 random pictures
    @pictures = Picture.find(:all, 
      :conditions => 'post_id is not null', 
      :order => 'RAND()', 
      :limit => 6)
  end

  # Responds with:
  # * a list of posts tagged with locations from the specified continent
  # * a selection of random pictures from the continent
  # * a list of countries to browse within the continent
  # Parameters:: continent_code, page
  # Route:: GET /browse/:continent_code.:continent_name
  def continent
    # Get the specified continent, checking that it exists
    if !@continent = Continent.find_by_code(params[:continent_code])
      raise ActiveRecord::RecordNotFound
    end
    
    # Pass through posts that are not empty, and have one or more location tag
    # within the specified continent
    @posts = Post.paginate(:all, 
      :select => 'distinct posts.*',
      :joins => 'left outer join locations_posts lp on posts.id = lp.post_id 
                 left outer join locations l on lp.location_id = l.id 
                 left outer join countries c on l.country_code = c.code
                 left outer join continents co on c.continent_id = co.id', 
      :conditions => empty_post_filter + " and co.code = '#{params[:continent_code]}'",
      :page => params[:page], :per_page => 5,
      :order => 'created_at DESC')
    
    # Pass through 6 random pictures from posts that are tagged within the
    # specified continent
    @pictures = Picture.find(:all, 
      :select => 'distinct continent_pictures.*',
      :from =>   "(select distinct pictures.*
                  from pictures
                  inner join locations l on pictures.location_id = l.id
                  inner join countries c on l.country_code = c.code
                  inner join continents co on c.continent_id = co.id where co.code = '#{params[:continent_code]}'
                  limit 6
                  union
                  select distinct pictures.*
                  from pictures
                  inner join posts p on pictures.post_id = p.id
                  inner join locations_posts lp on p.id = lp.post_id
                  inner join locations l on lp.location_id = l.id
                  inner join countries c on l.country_code = c.code
                  inner join continents co on c.continent_id = co.id where co.code = '#{params[:continent_code]}'
                  limit 6) as continent_pictures", 
      :order => 'RAND()', :limit => 6)
  end

  # Responds with:
  # * a list of posts tagged with locations from the specified country
  # * a selection of random pictures from the country
  # Parameters:: continent_code, country_code, page
  # Route:: GET /browse/:continent_code.:continent_name/:country_code.:country_name
  def country
    # Get the specified continent and country, checking that they exist
    if !@continent = Continent.find_by_code(params[:continent_code])
      raise ActiveRecord::RecordNotFound
    end
    @country = Country.find(params[:country_code])
    
    # Pass through posts that are not empty, and have one or more location tag
    # within the specified country
    @posts = Post.paginate(:all, 
      :select => 'distinct posts.*',
      :joins => 'left outer join locations_posts lp on posts.id = lp.post_id 
                 left outer join locations l on lp.location_id = l.id', 
      :conditions => empty_post_filter + " and l.country_code = '#{params[:country_code]}'",
      :page => params[:page], :per_page => 5,
      :order => 'created_at DESC')
    
    # Pass through 6 random pictures from posts that are tagged within the
    # specified country
    @pictures = Picture.find(:all, 
      :select => 'distinct country_pictures.*',
      :from => "(select distinct pictures.*
                from pictures
                inner join locations l on pictures.location_id = l.id where l.country_code = '#{params[:country_code]}'
                limit 6
                union
                select distinct pictures.*
                from pictures
                inner join posts p on pictures.post_id = p.id
                inner join locations_posts lp on p.id = lp.post_id
                inner join locations l on lp.location_id = l.id where l.country_code = '#{params[:country_code]}'
                limit 6) as country_pictures", 
      :order => 'RAND()', :limit => 5)
  end

  # Responds with:
  # * a list of posts tagged with the specified location
  # * a selection of random pictures from the location
  # Parameters:: continent_code, country_code, location_id, page
  # Route:: GET /browse/:continent_code.:continent_name/:country_code.:country_name/:location_id.:location_name
  def location
    # Get the specified location, checking that it exists
    @location = Location.find(params[:location_id])
    
    # If the location has a country, get the specified country and continent,
    # checking that they exist
    if @location.country
      if !@continent = Continent.find_by_code(params[:continent_code])
        ActiveRecord::RecordNotFound
      end
      @country = Country.find(params[:country_code])
    end
    
    # Pass through posts that are not empty, and are tagged with the specified
    # location
    @posts = Post.paginate(:all, 
      :select => 'distinct posts.*',
      :joins => 'left outer join locations_posts lp on posts.id = lp.post_id', 
      :conditions => empty_post_filter + " and lp.location_id = '#{params[:location_id]}'",
      :page => params[:page], :per_page => 5,
      :order => 'created_at DESC')
    
    # Pass through 6 random pictures from posts that are tagged with the
    # specified location
    @pictures = Picture.find(:all, 
      :select => 'distinct location_pictures.*',
      :from => "(select distinct pictures.*
                from pictures
                inner join locations l on pictures.location_id = l.id where l.id = #{params[:location_id]}
                limit 6
                union
                select distinct pictures.*
                from pictures
                inner join posts p on pictures.post_id = p.id
                inner join locations_posts lp on p.id = lp.post_id where lp.location_id = #{params[:location_id]}
                limit 6) as location_pictures",
      :order => 'RAND()', :limit => 5)
  end
end
