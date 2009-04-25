require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  include LocationsHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper
  include ActionController::UrlWriter
  fixtures :locations
  
  def test_display_location_no_country
    assert_equal display_location(locations(:no_country), false, true), 
      "<a href=\"http://#{$DEFAULT_HOST}/browse/#{locations(:no_country).id}.#{locations(:no_country).name}\">#{locations(:no_country).name}</a>"
  end
end