require 'test_helper'

class NotesRoutingTest < ActiveSupport::TestCase
  def test_note_post
    assert_generates "/posts/1/note", 
      :controller => 'notes', 
      :action => 'create',
      :post_id => '1'
    assert_recognizes({ :controller => 'notes', 
      :action => 'create',
      :post_id => '1' },
      { :path => "/posts/1/note",
        :method => :post })
  end
  
  def test_note_picture
    assert_generates "/pictures/1/note", 
      :controller => 'notes', 
      :action => 'create',
      :picture_id => '1'
    assert_recognizes({ :controller => 'notes', 
      :action => 'create',
      :picture_id => '1' },
      { :path => "/pictures/1/note",
        :method => :post })
  end
  
  def test_destroy_note
    assert_generates "/notes/1/remove", 
      :controller => 'notes', 
      :action => 'destroy',
      :id => '1'
    assert_recognizes({ :controller => 'notes', 
      :action => 'destroy',
      :id => '1' },
      { :path => "/notes/1/remove",
        :method => :delete })
  end
end
