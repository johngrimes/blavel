require 'test_helper'

class LocationsRoutingTest < ActiveSupport::TestCase
  def test_location_search
    assert_generates "/locations/search", 
      :controller => 'locations', 
      :action => 'search'
    assert_recognizes({ :controller => 'locations', 
      :action => 'search' },
      "/locations/search")
  end
  
  def test_location_search_query
    assert_generates "/locations/search/hill", 
      :controller => 'locations', 
      :action => 'search',
      :query => 'hill'
    assert_recognizes({ :controller => 'locations', 
      :action => 'search',
      :query => 'hill' },
      "/locations/search/hill")
  end
  
  def test_location_map
    assert_generates "/map/1,2/3,4", 
      :controller => 'locations', 
      :action => 'map',
      :post_location_ids => '1,2',
      :picture_location_ids => '3,4'
    assert_recognizes({ :controller => 'locations', 
      :action => 'map',
      :post_location_ids => '1,2',
      :picture_location_ids => '3,4' },
      "/map/1,2/3,4")
  end
  
  def test_picture_map
    assert_generates "/map//3,4", 
      :controller => 'locations', 
      :action => 'map',
      :picture_location_ids => '3,4'
    assert_recognizes({ :controller => 'locations', 
      :action => 'map',
      :picture_location_ids => '3,4' },
      "/map//3,4")
  end
  
  def test_post_map
    assert_generates "/map/1,2", 
      :controller => 'locations', 
      :action => 'map',
      :post_location_ids => '1,2'
    assert_recognizes({ :controller => 'locations', 
      :action => 'map',
      :post_location_ids => '1,2' },
      "/map/1,2")
  end
end
