require 'test_helper'

class BrowseControllerTest < ActionController::TestCase
  fixtures :continents, :countries, :locations
  
  # START Browse Action Tests
  
  def test_get_index
    get :index
    assert_response :success
  end
  
  def test_get_continent
    get :continent, 
      :continent_code => continents(:europe).code,
      :continent_name => continents(:europe).name
    assert_response :success
  end
  
  def test_get_country
    get :country,
      :continent_code => continents(:europe).code,
      :continent_name => continents(:europe).name.gsub(/\s/, '-'),
      :country_code => countries(:uk).id,
      :country_name => countries(:uk).name.gsub(/\s/, '-')
    assert_response :success
  end
  
  def test_get_location
    get :location,
      :continent_code => continents(:europe).code,
      :continent_name => continents(:europe).name.gsub(/\s/, '-'),
      :country_code => countries(:uk).id,
      :country_name => countries(:uk).name.gsub(/\s/, '-'),
      :location_id => locations(:bay).id,
      :location_name => locations(:bay).name.gsub(/\s/, '-')
    assert_response :success
  end
  
  # END Browse Action Tests
  
  # START Browse Defect Tests
  
  def test_get_nonexistent_continent
    assert_raise(ActiveRecord::RecordNotFound) {
      get :continent, 
      :continent_code => 'GL',
      :continent_name => 'Gondwanaland'
    }
  end
  
  def test_get_nonexistent_country
    assert_raise(ActiveRecord::RecordNotFound) {
      get :country,
      :continent_code => continents(:europe).code,
      :continent_name => continents(:europe).name,
      :country_code => 'ZZ',
      :country_name => 'Zazuland'
    }
  end
  
  def test_get_nonexistent_location
    assert_raise(ActiveRecord::RecordNotFound) {
      get :location,
      :continent_code => continents(:europe).code,
      :continent_name => continents(:europe).name.gsub(/\s/, '-'),
      :country_code => countries(:uk).id,
      :country_name => countries(:uk).name.gsub(/\s/, '-'),
      :location_id => 999999999999,
      :location_name => 'Old Apple Tree'
    }
  end
  
  def test_get_location_no_country
    get :location,
      :location_id => locations(:no_country).id,
      :location_name => locations(:no_country).name
  end
  
  # END Browse Defect Tests
end
