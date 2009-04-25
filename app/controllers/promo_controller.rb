class PromoController < ApplicationController
  layout 'empty'
  
  # Responds with non-member welcome page.
  # Route:: GET /home
  def home
  end
  
  # Responds with Sitemaps.org-compliant sitemap file.
  # Route:: GET /sitemap.xml
  def sitemap
    
    # Pass through all posts
    @posts = Post.find(:all)
    
    # Pass through all pictures, except those which are merely children of other 
    # pictures for the purposes of storing different sizes
    @pictures = Picture.find(:all, :conditions => 'parent_id IS NULL')
    
    # Pass through all users, except for those who have got no posts
    @users = User.find(:all)
    @users = @users.reject {|user| !user.posts || user.posts.length == 0 }
    
    # Get all locations that have been tagged in posts or pictures
    @locations = Location.connection.select_all('SELECT DISTINCT location_id FROM locations_posts') +
      Location.connection.select_all('SELECT DISTINCT location_id FROM pictures')
    @locations = @locations.uniq
    @locations = @locations.reject {|location| location['location_id'].nil? }
    
    # Use the country and continent from each locations to build up a list
    # of countries and continents that have been posted about on the site
    @active_locations = []
    @active_countries = []
    @active_continents = []
    @locations.each do |location|
      @active_locations.push Location.find(location['location_id'])
      @active_countries.push @active_locations.last.country
      @active_continents.push @active_countries.last.continent
    end
    @active_countries = @active_countries.uniq
    @active_continents = @active_continents.uniq
    
    # Render sitemap file
    render :template => 'promo/sitemap.rxml', :layout => false
  end
  
  # Redirects to the Blavel documentation.
  # Route:: GET /opencode
  def doco
    redirect_to '/opencode/index.html'
  end
end
