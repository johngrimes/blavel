require 'test_helper'

class UsersRoutingTest < ActiveSupport::TestCase
  def test_join
    assert_generates "/join", 
      :controller => 'users', 
      :action => 'new'
    assert_recognizes({ :controller => 'users', 
      :action => 'new' },
      "/join")
  end
  
  def test_create_user
    assert_generates "/users", 
      :controller => 'users', 
      :action => 'create'
    assert_recognizes({ :controller => 'users', 
      :action => 'create' },
      { :path => "/users",
        :method => :post })
  end
  
  def test_activation_instructions
    assert_generates "/bandersnatch/activate", 
      :controller => 'users', 
      :action => 'activation',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'activation',
      :user_login => 'bandersnatch' },
      "/bandersnatch/activate")
  end
  
  def test_activate
    assert_generates "/activate/iewiorug240ot879fgqd", 
      :controller => 'users', 
      :action => 'activate',
      :activation_code => 'iewiorug240ot879fgqd'
    assert_recognizes({ :controller => 'users', 
      :action => 'activate',
      :activation_code => 'iewiorug240ot879fgqd' },
      "/activate/iewiorug240ot879fgqd")
  end
  
  def test_user_profile
    assert_generates "/bandersnatch", 
      :controller => 'users', 
      :action => 'show',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'show',
      :user_login => 'bandersnatch' },
      "/bandersnatch")
  end
  
  def test_user_profile_page
    assert_generates "/bandersnatch/page.5", 
      :controller => 'users', 
      :action => 'show',
      :user_login => 'bandersnatch',
      :page => '5'
    assert_recognizes({ :controller => 'users', 
      :action => 'show',
      :user_login => 'bandersnatch',
      :page => '5' },
      "/bandersnatch/page.5")
  end
  
  def test_get_profile_pic
    assert_generates "/bandersnatch/profile-pic/display", 
      :controller => 'users', 
      :action => 'get_profile_pic',
      :user_login => 'bandersnatch',
      :format => 'display'
    assert_recognizes({ :controller => 'users', 
      :action => 'get_profile_pic',
      :user_login => 'bandersnatch',
      :format => 'display' },
      "/bandersnatch/profile-pic/display")
  end
  
  def test_edit_profile
    assert_generates "/bandersnatch/edit", 
      :controller => 'users', 
      :action => 'edit',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'edit',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/edit",
        :method => :get })
  end
  
  def test_update_profile
    assert_generates "/bandersnatch/edit", 
      :controller => 'users', 
      :action => 'update',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'update',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/edit",
        :method => :put })
  end
  
  def test_upload_picture
    assert_generates "/bandersnatch/picture/upload", 
      :controller => 'users', 
      :action => 'upload_picture',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'upload_picture',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/picture/upload",
        :method => :get })
  end
  
  def test_update_picture
    assert_generates "/bandersnatch/picture/upload", 
      :controller => 'users', 
      :action => 'update_picture',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'users', 
      :action => 'update_picture',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/picture/upload",
        :method => :put })
  end
end
