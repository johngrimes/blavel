require 'test_helper'

class FeedRoutingTest < ActiveSupport::TestCase
  def test_base
    assert_generates '',
      :controller => 'feeds',
      :action => 'feed'
    assert_recognizes({ :controller => 'feeds',
      :action => 'feed' },
      '')
  end
  
  def test_user_rss_feed
    assert_generates "/bandersnatch/feed",
      :controller => 'feeds',
      :action => 'rss',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'feeds',
      :action => 'rss',
      :user_login => 'bandersnatch' },
      "/bandersnatch/feed")
  end
  
  def test_everybody_feed
    assert_generates "/feed/everybody", 
      :controller => 'feeds', 
      :action => 'feed',
      :everybody => true
    assert_recognizes({ :controller => 'feeds', 
      :action => 'feed',
      :everybody => true },
      "/feed/everybody")
  end  
end
