require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  fixtures :locations
  
  # START Locations Action Tests
  
  def test_search
    get :search,
      :query => 'furrowend'
    assert_response :success
    #TODO: Figure out why this doesn't work
    #assert_tag :tag => 'Location'
  end
  
  def test_map
    get :map,
      :post_location_ids => [].push(locations(:bay).id),
      :picture_location_ids => [].push(locations(:windsor).id)
    assert_response :success
  end
  
  # END Locations Actions Tests
  
  # START Locations Defect Tests
  
  def test_map_nonexistent_location
    assert_raise(ActiveRecord::RecordNotFound) {
      get :map,
      :post_location_ids => [].push(999999999999)
    }
  end
  
  # END Locations Defect Tests
end
