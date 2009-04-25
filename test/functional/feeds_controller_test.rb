require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users
  
  def setup
    login_as :quentin
  end
  
  # START Feed Action Tests
  
  def test_get_feed
    get :feed
    assert_response :success
  end
  
  def test_get_ajax_feed
    @request.accept = 'text/javascript'
    get :feed
    assert_response :success
    assert @response.content_type == 'text/javascript'
  end
  
  def test_get_everybody_feed
    get :feed,
      :everybody => true
    assert_response :success
  end
  
  def test_get_rss
    get :rss,
      :user_login => users(:quentin).login
    assert_response :success
  end  
  
  # END Feed Action Tests
  
  # START Feed Defect Tests
  # END Feed Defect Tests
end
