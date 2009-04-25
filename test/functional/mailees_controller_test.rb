require 'test_helper'

class MaileesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users, :posts, :mailees
    
  def setup
    login_as :quentin
  end
  
  # START Mailees Action Tests
  
  def test_show
    get :show,
      :post_id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_add
    post :add,
      :user_login => users(:quentin).login,
      :add_mailee => 'test_quire@blavel.com',
      :post_id => posts(:by_quentin).id
    assert_response :redirect
  end
  
  def test_destroy
    delete :destroy,
      :user_login => users(:quentin).login,
      :remove_mailee => mailees(:by_quentin).id,
      :post_id => posts(:by_quentin).id
    assert_response :redirect
  end
  
  def test_send_to
    post :send_to,
      :post_id => posts(:by_quentin).id,
      :to_send => [].push('1')
    assert_response :redirect
  end
  
  # END Mailees Action Tests
  
  # START Mailees Defect Tests
  
  def test_mailees_show_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show,
      :post_id => 99
    }
  end
  
  # END Mailees Defect Tests
end
