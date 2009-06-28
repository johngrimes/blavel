require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper, FileUtilities
  fixtures :pictures, :posts
    
  def setup
    login_as :quentin
  end
  
  # START Pictures Action Tests
  
  def test_show
    get :show,
      :id => pictures(:by_quentin).id
    assert_response :success
  end
  
  def test_show_all
    get :show_all,
      :post_id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_add
    get :add,
      :post_id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_edit
    get :edit,
      :post_id => posts(:by_quentin).id
    assert_response :success
  end
  
  def test_create
    picture_data = uploaded_file($SAMPLE_PICTURE_PATH, 'image/jpeg')
    assert_difference 'Picture.count', +4 do
      post :create,
        :post_id => posts(:by_quentin).id,
        :ugly => users(:quentin).id,
        :goblin => users(:quentin).crypted_password,
        :picture => picture_data
      assert_response :success
    end
  end
  
  def test_update
    put :update,
      :post_id => posts(:by_quentin).id,
      :picture => {
      "#{pictures(:by_quentin).id}" => {
        :title => 'Updated title',
        :description => 'Updated description',
        :location => locations(:bay).id,
        :sequence => '1' }        
    }
    assert_response :redirect
  end
  
  def test_destroy
    assert_difference 'Picture.count', -1 do
      delete :destroy,
        :id => pictures(:by_quentin).id
      assert_response :redirect
    end
  end
  
  # END Pictures Action Tests
  
  # START Pictures Defect Tests
  
  def test_show_nonexistent_picture
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show,
      :id => 99
    }
  end
  
  def test_show_all_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show_all,
      :post_id => 99
    }
  end
  
  def test_edit_nonexistent_post
    assert_raise(ActiveRecord::RecordNotFound) {
      get :edit,
      :post_id => 99      
    }
  end
  
  def test_destroy_nonexistent_picture
    assert_raise(ActiveRecord::RecordNotFound) {
      delete :destroy,
      :id => 99
    }
  end
  
  def test_update_containing_quote
    put :update,
      :post_id => posts(:by_quentin).id,
      :picture => {
      "#{pictures(:by_quentin).id}" => {
        :title => 'Updated title',
        :description => "Don't you think this should work?",
        :location => locations(:bay).id,
        :sequence => '1' }
    }
    assert_response :redirect
    
    updated_picture = Picture.find(pictures(:by_quentin).id)
    assert updated_picture.description == "Don&#39;t you think this should work?"
  end
  
  # END Pictures Defect Tests
end
