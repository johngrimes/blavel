require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def test_utfness
    post = Post.new
    post.title = 'كوهِ شُتُر خواب'
    post.save
    assert post.title = 'كوهِ شُتُر خواب'
  end
end
