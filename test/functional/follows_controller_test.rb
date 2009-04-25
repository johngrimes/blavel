require 'test_helper'

class FollowsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :follows
  
  def setup
    login_as :quentin
  end
  
  # START Follows Action Tests
  
  def test_follow_user
    post :follow,
      :user_login => users(:aaron).login
    assert_response :redirect
  end
  
  def test_unfollow_user
    delete :unfollow,
      :user_login => users(:aaron).login
    assert_response :redirect
  end
  
  def test_show_all_followers
    get :show_all_followers,
      :user_login => users(:aaron).login
    assert_response :success
  end
  
  def test_show_all_followees
    get :show_all_followees,
      :user_login => users(:aaron).login
    assert_response :success
  end
  
  # END Follows Action Tests
  
  # START Follows Defect Tests
  # END Follows Defect Tests
end
