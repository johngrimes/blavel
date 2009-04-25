require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users, :locations
    
  def setup
    login_as :quentin
  end
  
  # START Posts Action Tests
  
  def test_show
    get :show,
      :id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_new
    get :new
    assert_response :success
  end
  
  def test_edit
    get :edit,
      :id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_create
    post :create,
      :post => { :title => 'Test entry',
      :content => 'Some test content...',
      :location_ids => [ locations(:bay).id, locations(:windsor).id ] }
  end
  
  def test_update
    put :update,
      :id => posts(:by_quentin).id,
      :post => { :title => 'Updated entry',
      :content => 'Updated content...' }
    assert_response :redirect
  end
  
  def test_destroy
    delete :destroy,
      :id => posts(:by_quentin).id
    assert_response :redirect
  end
  
  # END Posts Action Tests
  
  # START Posts Defect Tests
  
  def test_show_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show,
      :id => 99
    }
  end
  
  def test_edit_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      get :edit,
      :id => 99
    }
  end
  
  def test_destroy_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      delete :destroy,
      :id => 99
    }
  end
  
  def test_tag_post_location_no_country
    post :create,
      :post => { :title => 'Test entry',
      :content => 'Some test content...',
      :location_ids => [ locations(:no_country).id ] }
  end
  
  # END Posts Defect Tests
end
