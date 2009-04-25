require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :users, :messages
  
  def test_sender_link
    assert_not_nil messages(:one).sender
    assert messages(:one).sender == users(:quentin)
  end
  
  def test_recipient_link
    assert_not_nil messages(:one).recipient
    assert messages(:one).recipient = users(:aaron)
  end
end
