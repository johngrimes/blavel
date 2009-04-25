require 'test_helper'

class MessagesRoutingTest < ActiveSupport::TestCase
  def test_new_message
    assert_generates "/messages/new/Sharrie",
      :controller => 'messages',
      :action => 'new',
      :user_login => 'Sharrie'
    assert_recognizes({ :controller => 'messages',
      :action => 'new',
      :user_login => 'Sharrie' },
      "/messages/new/Sharrie")
  end

  def test_create_message
    assert_generates "/messages",
      :controller => 'messages',
      :action => 'create'
    assert_recognizes({ :controller => 'messages',
      :action => 'create' },
      { :path => "/messages",
        :method => :post })
  end

  def test_show_message
    assert_generates "/messages/5",
      :controller => 'messages',
      :action => 'show',
      :id => '5'
    assert_recognizes({ :controller => 'messages',
      :action => 'show',
      :id => '5' },
      "/messages/5")
  end

  def test_manage_messages
    assert_generates "/messages",
      :controller => 'messages',
      :action => 'manage'
    assert_recognizes({ :controller => 'messages',
      :action => 'manage' },
      "/messages")
  end

  def test_message_convo
    assert_generates "/messages/5/convo",
      :controller => 'messages',
      :action => 'convo',
      :id => '5'
    assert_recognizes({ :controller => 'messages',
      :action => 'convo',
      :id => '5' },
      "/messages/5/convo")
  end

  def test_mark_message_read
    assert_generates "/messages/read",
      :controller => 'messages',
      :action => 'mark_as_read'
    assert_recognizes({ :controller => 'messages',
      :action => 'mark_as_read' },
      { :path => "/messages/read",
        :method => :post })
  end
end
