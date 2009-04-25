require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  fixtures :locations
  
  def test_utfness
    assert locations(:windsor).alternate_names = 'New Windsor,Vindzor,Windlesora,Windlesōra,Windsor,Виндзор,ウィンザー'
  end
end
