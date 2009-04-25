require 'test_helper'

class ContinentTest < ActiveSupport::TestCase
  fixtures :continents, :countries
  
  def test_country_link
    assert_not_nil continents(:europe).countries
  end
end
