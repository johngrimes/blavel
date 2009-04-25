require 'test_helper'

class PromoControllerTest < ActionController::TestCase

  # START Promo Action Tests
 
  def test_home
    get :home
    assert_response :success
  end
  
  def test_sitemap
    get :sitemap
    assert_response :success
  end
  
  def test_doco  
    get :doco
    assert_response :redirect
  end
  
  # END Promo Action Tests
  
  # START Promo Defect Tests
  # END Promo Defect Tests
end
