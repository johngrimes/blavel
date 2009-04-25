require 'test_helper'

class PostsRoutingTest < ActiveSupport::TestCase
  def test_show_post_long
    assert_generates "/travel-blogs/GB.United-Kingdom/2638138.Shanklin/66", 
      :controller => 'posts', 
      :action => 'show',
      :country_code => 'GB',
      :country_name => 'United-Kingdom',
      :location_id => '2638138',
      :location_name => 'Shanklin',
      :id => '66'
    assert_recognizes({ :controller => 'posts', 
      :action => 'show',
      :country_code => 'GB',
      :country_name => 'United-Kingdom',
      :location_id => '2638138',
      :location_name => 'Shanklin',
      :id => '66' },
      "/travel-blogs/GB.United-Kingdom/2638138.Shanklin/66")
  end
  
  def test_show_post_medium
    assert_generates "/travel-blogs/2638138.Shanklin/66", 
      :controller => 'posts', 
      :action => 'show',
      :location_id => '2638138',
      :location_name => 'Shanklin',
      :id => '66'
    assert_recognizes({ :controller => 'posts', 
      :action => 'show',
      :location_id => '2638138',
      :location_name => 'Shanklin',
      :id => '66' },
      "/travel-blogs/2638138.Shanklin/66")
  end
  
  def test_show_post_short
    assert_generates "/travel-blogs/66", 
      :controller => 'posts', 
      :action => 'show',
      :id => '66'
    assert_recognizes({ :controller => 'posts', 
      :action => 'show',
      :id => '66' },
      "/travel-blogs/66")
  end
  
  def test_new_post
    assert_generates "/posts/new", 
      :controller => 'posts', 
      :action => 'new'
    assert_recognizes({ :controller => 'posts', 
      :action => 'new' },
      "/posts/new")
  end
  
  def test_create_post
    assert_generates "/posts", 
      :controller => 'posts', 
      :action => 'create'
    assert_recognizes({ :controller => 'posts', 
      :action => 'create' },
      { :path => "/posts",
        :method => :post })
  end
  
  def test_edit_post
    assert_generates "/posts/1/edit", 
      :controller => 'posts', 
      :action => 'edit',
      :id => '1'
    assert_recognizes({ :controller => 'posts', 
      :action => 'edit',
      :id => '1' },
      "/posts/1/edit")
  end
  
  def test_update_post
    assert_generates "/posts/1", 
      :controller => 'posts', 
      :action => 'update',
      :id => '1'
    assert_recognizes({ :controller => 'posts', 
      :action => 'update',
      :id => '1' },
      { :path => "/posts/1",
        :method => :put })
  end
  
  def test_destroy_post
    assert_generates "/posts/1", 
      :controller => 'posts', 
      :action => 'destroy',
      :id => '1'
    assert_recognizes({ :controller => 'posts', 
      :action => 'destroy',
      :id => '1' },
      { :path => "/posts/1",
        :method => :delete })
  end
end
