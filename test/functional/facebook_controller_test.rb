require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  fixtures :users
  
  # START Facebook Action Tests
  
  def test_index
    facebook_get :index
    assert_response :success
  end
  
  def test_new_link
    facebook_get :new_link
    assert_response :success
  end
  
  def test_tab
    facebook_get :tab
    assert_response :success
  end
  
  def test_create_link
    facebook_post :create_link,
      :login => users(:quentin).login,
      :password => users(:quentin).password
    assert_response :success
  end
  
  # END Facebook Action Tests
  
  # START Facebook Defect Tests
  # END Facebook Defect Tests
end
