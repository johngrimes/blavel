require 'test_helper'

class BrowseRoutingTest < ActiveSupport::TestCase
  def test_browse
    assert_generates "/browse", 
      :controller => 'browse', 
      :action => 'index'
    assert_recognizes({ :controller => 'browse', 
        :action => 'index' },
      "/browse")
  end
  
  def test_browse_page
    assert_generates "/browse/page.3", 
      :controller => 'browse', 
      :action => 'index',
      :page => '3'
    assert_recognizes({ :controller => 'browse', 
      :action => 'index',
      :page => '3' },
      "/browse/page.3")
  end
  
  def test_browse_continent
    assert_generates "/browse/OC.Oceania", 
      :controller => 'browse', 
      :action => 'continent',
      :continent_code => 'OC',
      :continent_name => 'Oceania'
    assert_recognizes({ :controller => 'browse', 
      :action => 'continent',
      :continent_code => 'OC',
      :continent_name => 'Oceania' },
      "/browse/OC.Oceania")
  end
  
  def test_browse_continent_page
    assert_generates "/browse/OC.Oceania/page.2", 
      :controller => 'browse', 
      :action => 'continent',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :page => '2'
    assert_recognizes({ :controller => 'browse', 
      :action => 'continent',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :page => '2' },
      "/browse/OC.Oceania/page.2")
  end
  
  def test_browse_country
    assert_generates "/browse/OC.Oceania/AU.Australia", 
      :controller => 'browse', 
      :action => 'country',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia'
    assert_recognizes({ :controller => 'browse', 
      :action => 'country',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia' },
      "/browse/OC.Oceania/AU.Australia")
  end
  
  def test_browse_country_page
    assert_generates "/browse/OC.Oceania/AU.Australia/page.4", 
      :controller => 'browse', 
      :action => 'country',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :page => '4'
    assert_recognizes({ :controller => 'browse', 
      :action => 'country',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :page => '4' },
      "/browse/OC.Oceania/AU.Australia/page.4")
  end
  
  def test_browse_location
    assert_generates "/browse/OC.Oceania/AU.Australia/2174003.Brisbane", 
      :controller => 'browse', 
      :action => 'location',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :location_id => '2174003',
      :location_name => 'Brisbane'
    assert_recognizes({ :controller => 'browse', 
      :action => 'location',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :location_id => '2174003',
      :location_name => 'Brisbane' },
      "/browse/OC.Oceania/AU.Australia/2174003.Brisbane")
  end
  
  def test_browse_location_page
    assert_generates "/browse/OC.Oceania/AU.Australia/2174003.Brisbane/page.9", 
      :controller => 'browse', 
      :action => 'location',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :location_id => '2174003',
      :location_name => 'Brisbane',
      :page => '9'
    assert_recognizes({ :controller => 'browse', 
      :action => 'location',
      :continent_code => 'OC',
      :continent_name => 'Oceania',
      :country_code => 'AU',
      :country_name => 'Australia',
      :location_id => '2174003',
      :location_name => 'Brisbane',
      :page => '9' },
      "/browse/OC.Oceania/AU.Australia/2174003.Brisbane/page.9")
  end
  
  def test_browse_location_no_country
    assert_generates "/browse/2174553.Brisbane-Tablemount", 
      :controller => 'browse', 
      :action => 'location',
      :location_id => '2174553',
      :location_name => 'Brisbane-Tablemount'
    assert_recognizes({ :controller => 'browse', 
      :action => 'location',
      :location_id => '2174553',
      :location_name => 'Brisbane-Tablemount' },
      "/browse/2174553.Brisbane-Tablemount")
  end
  
  def test_browse_location_no_country_page
    assert_generates "/browse/2174553.Brisbane-Tablemount/page.9", 
      :controller => 'browse', 
      :action => 'location',
      :location_id => '2174553',
      :location_name => 'Brisbane-Tablemount',
      :page => '9'
    assert_recognizes({ :controller => 'browse', 
      :action => 'location',
      :location_id => '2174553',
      :location_name => 'Brisbane-Tablemount',
      :page => '9' },
      "/browse/2174553.Brisbane-Tablemount/page.9")
  end    
end
