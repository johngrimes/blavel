require 'riddle.rb'

class Location < ActiveRecord::Base
  belongs_to :country, :foreign_key => 'country_code'   # Country of location
  has_many :pictures
  has_and_belongs_to_many :posts

  # Access the description associated with the type of this location.
  def type_description
    type = LocationType.find_by_code(self.location_type_code)
    if (type)
      type.description
    else
      nil
    end
  end

  # Return results of a textual search of locations, based on the specified
  # query.
  def self.search(query)

    # Create a new Riddle (Sphinx) client and set the match mode to extended.
    # Extended match mode means that operators can be used in the query string
    search_client = Riddle::Client.new
    search_client.match_mode = :extended

    # Set the weighting of results from the whole word and prefix indexes
    # The whole word index returns only whole word matches, while the prefix
    # index matches characters at the start of words
    # This weighting values whole word matches more highly than matches on
    # only the first part of a word
    search_client.index_weights = {
      'locations_wholeword_index' => 100,
      'locations_prefix_index' => 50,
    }

    # Set the weighting of the fields of a location
    # This weighting values a match on the name of a location more highly than
    # a match on the alternate name for that location
    # country_name is set to the highest value to prevent the problem of places
    # that are called the same name as countries scoring higher in search
    # rankings, e.g. United Nations, United States of America
    search_client.field_weights = {
      'name' => 80,
      'alternate_names' => 50,
      'country_name' => 100,
      'type' => 30
    }

    # Query the search server
    result = search_client.query query

    # Retrieve the full location record for each search result and store it in
    # an array
    locations = []
    result[:matches].each do |m|
      locations << Location.find(m[:doc])
    end

    # Return array of locations
    return locations
  end
end
