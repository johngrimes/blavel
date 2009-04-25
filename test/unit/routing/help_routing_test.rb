require 'test_helper'

class HelpRoutingTest < ActiveSupport::TestCase
  def test_help
    assert_generates "/help/facebook", 
      :controller => 'help', 
      :action => 'facebook'
    assert_recognizes({ :controller => 'help', 
      :action => 'facebook' },
      "/help/facebook")
  end
end
