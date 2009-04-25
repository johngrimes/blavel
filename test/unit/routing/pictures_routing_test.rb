require 'test_helper'

class PicturesRoutingTest < ActiveSupport::TestCase
  def test_get_picture_file
    assert_generates "/pictures/1/display", 
      :controller => 'pictures', 
      :action => 'get_file',
      :id => '1',
      :format => 'display'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'get_file',
      :id => '1',
      :format => 'display' },
      "/pictures/1/display")
  end
  
  def test_show_picture
    assert_generates "/pictures/1", 
      :controller => 'pictures', 
      :action => 'show',
      :id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'show',
      :id => '1' },
      { :path => "/pictures/1",
        :method => :get })
  end
  
  def test_show_all_pictures
    assert_generates "/posts/1/pictures",
      :controller => 'pictures',
      :action => 'show_all',
      :post_id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'show_all',
      :post_id => '1' },
      { :path => "/posts/1/pictures",
        :method => :get })
  end
  
  def test_add_pictures
    assert_generates "/posts/1/pictures/add",
      :controller => 'pictures',
      :action => 'add',
      :post_id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'add',
      :post_id => '1' },
      "/posts/1/pictures/add")
  end
  
  def test_add_pictures_new_post
    assert_generates "/posts/new/pictures/add",
      :controller => 'pictures',
      :action => 'add',
      :new_post => true
    assert_recognizes({ :controller => 'pictures', 
      :action => 'add',
      :new_post => true },
      "/posts/new/pictures/add")
  end
  
  def test_create_picture
    assert_generates "/posts/1/pictures",
      :controller => 'pictures',
      :action => 'create',
      :post_id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'create',
      :post_id => '1' },
      { :path => "/posts/1/pictures",
        :method => :post })
  end
  
  def test_edit_pictures
    assert_generates "/posts/1/pictures/edit",
      :controller => 'pictures',
      :action => 'edit',
      :post_id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'edit',
      :post_id => '1' },
      "/posts/1/pictures/edit")
  end
  
  def test_update_pictures
    assert_generates "/posts/1/pictures",
      :controller => 'pictures',
      :action => 'update',
      :post_id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'update',
      :post_id => '1' },
      { :path => "/posts/1/pictures",
        :method => :put })
  end
  
  def test_destroy_picture
    assert_generates "/pictures/1",
      :controller => 'pictures',
      :action => 'destroy',
      :id => '1'
    assert_recognizes({ :controller => 'pictures', 
      :action => 'destroy',
      :id => '1' },
      { :path => "/pictures/1",
        :method => :delete })
  end
end
