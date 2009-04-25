require 'test_helper'

class HelpControllerTest < ActionController::TestCase

  # START Help Action Tests

  def test_facebook
    get :facebook
    assert_response :success
  end

  def test_uploading_pictures
    get :uploading_pictures
    assert_response :success
  end

  def test_messaging
    get :messaging
    assert_response :success
  end

  # END Help Action Tests

  # START Help Defect Tests
  # END Help Defect Tests
end
