class LocationsController < ApplicationController
  
  # Responds with search results for a location search query.
  # Parameters:: query
  # Route:: /locations/search/:query
  def search
    @locations = Location.search params[:query]
  end
  
  # Responds with a map of any number of post and/or picture locations.
  # Parameters:: post_location_ids, picture_location_ids
  # Route:: /map/:post_location_ids/:picture_location_ids
  def map
    @post_locations = []
    @picture_locations = []
    
    unless params[:post_location_ids].blank?
      
      # Pass through each comma-delimited post location id
      params[:post_location_ids].split(',').each do |l|
        if !@location = Location.find_by_id(l)
          raise ActiveRecord::RecordNotFound
        end
        @post_locations.push @location
      end
    end
    
    unless params[:picture_location_ids].blank?
      
      # Pass through each comma-delimited picture location id
      params[:picture_location_ids].split(',').each do |l|
        if !@location = Location.find_by_id(l)
          ActiveRecord::RecordNotFound
        end
        @picture_locations.push @location
      end
    end
  end
end
