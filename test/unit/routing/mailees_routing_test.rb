require 'test_helper'

class MaileesRoutingTest < ActiveSupport::TestCase
  def test_show_mailing_list
    assert_generates "/posts/1/mailing", 
      :controller => 'mailees', 
      :action => 'show',
      :post_id => '1'
    assert_recognizes({ :controller => 'mailees', 
      :action => 'show',
      :post_id => '1' },
      { :path => "/posts/1/mailing",
        :method => :get })
  end
  
  def test_send_mailing_list
    assert_generates "/posts/1/mailing", 
      :controller => 'mailees', 
      :action => 'send_to',
      :post_id => '1'
    assert_recognizes({ :controller => 'mailees', 
      :action => 'send_to',
      :post_id => '1' },
      { :path => "/posts/1/mailing",
        :method => :post })
  end
  
  def test_add_mailee
    assert_generates "/bandersnatch/mailees", 
      :controller => 'mailees', 
      :action => 'add',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'mailees', 
      :action => 'add',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/mailees",
        :method => :post })
  end
  
  def test_destroy_mailee
    assert_generates "/bandersnatch/mailees", 
      :controller => 'mailees', 
      :action => 'destroy',
      :user_login => 'bandersnatch'
    assert_recognizes({ :controller => 'mailees', 
      :action => 'destroy',
      :user_login => 'bandersnatch' },
      { :path => "/bandersnatch/mailees",
        :method => :delete })
  end
end
