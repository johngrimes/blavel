require 'test_helper'

class FollowsRoutingTest < ActiveSupport::TestCase
  def test_follow
    assert_generates "/bandersnatch/follow", 
      :controller => 'follows', 
      :action => 'follow',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'follows', 
        :action => 'follow',
        :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/follow",
        :method => :post })
  end
  
  def test_unfollow
    assert_generates "/bandersnatch/unfollow", 
      :controller => 'follows', 
      :action => 'unfollow',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'follows', 
        :action => 'unfollow',
        :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/unfollow",
        :method => :delete })
  end
  
  def test_show_all_followers
    assert_generates "/bandersnatch/followers", 
      :controller => 'follows', 
      :action => 'show_all_followers',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'follows', 
        :action => 'show_all_followers',
        :user_login => 'bandersnatch' },
        "/bandersnatch/followers")
  end
  
  def test_show_all_followees
    assert_generates "/bandersnatch/followees", 
      :controller => 'follows', 
      :action => 'show_all_followees',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'follows', 
        :action => 'show_all_followees',
        :user_login => 'bandersnatch' },
        "/bandersnatch/followees")
  end
end
