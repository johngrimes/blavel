require 'test_helper'

class SessionsRoutingTest < ActiveSupport::TestCase
  def test_login
    assert_generates "/login", 
      :controller => 'sessions', 
      :action => 'new'
    assert_recognizes({ :controller => 'sessions', 
      :action => 'new' },
      { :path => "/login",
        :method => :get })
  end
  
  def test_create_session
    assert_generates "/login", 
      :controller => 'sessions', 
      :action => 'create'
    assert_recognizes({ :controller => 'sessions', 
      :action => 'create' },
      { :path => "/login",
        :method => :post })
  end
  
  def test_logout
    assert_generates "/logout", 
      :controller => 'sessions', 
      :action => 'destroy'
    assert_recognizes({ :controller => 'sessions', 
      :action => 'destroy' },
      { :path => "/logout",
        :method => :delete })
  end
end
