require 'test_helper'

class FacebookRoutingTest < ActiveSupport::TestCase
  def test_fb_index
    assert_generates "/facebook", 
      :controller => 'facebook', 
      :action => 'index'
    assert_recognizes({ :controller => 'facebook', 
      :action => 'index' },
      "/facebook")
  end
  
  def test_fb_tab
    assert_generates "/facebook/tab", 
      :controller => 'facebook', 
      :action => 'tab'
    assert_recognizes({ :controller => 'facebook', 
      :action => 'tab' },
      "/facebook/tab")
  end
  
  def test_new_fb_link
    assert_generates "/facebook/link", 
      :controller => 'facebook', 
      :action => 'new_link'
    assert_recognizes({ :controller => 'facebook', 
      :action => 'new_link' },
      { :path => "/facebook/link",
        :method => :get })
  end
  
  def create_fb_link
    assert_generates "/facebook/link", 
      :controller => 'facebook', 
      :action => 'create_link'
    assert_recognizes({ :controller => 'facebook', 
      :action => 'create_link' }, 
      { :path => "/facebook/link",
        :method => :post })    
  end    
end
