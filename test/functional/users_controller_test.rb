require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper, FileUtilities

  fixtures :users, :follows

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    login_as :quentin
  end

  # START Authenticated System Tests

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:email => nil)
      assert_response :success
    end
  end

  def test_should_sign_up_user_with_activation_code
    create_user
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  def test_should_activate_user
    assert_nil User.authenticate('aaron', 'test')
    get :activate, :activation_code => users(:aaron).activation_code
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
    assert_equal users(:aaron), User.authenticate('aaron', 'test')
  end

  def test_should_not_activate_user_without_key
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end

  # END Authenticated System Tests

  # START User Action Tests

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    post :create,
      :login => 'barry',
      :email => 'test_barry@blavel.com',
      :password => 'barry',
      :password_confirmation => 'barry'
    assert_response :success
  end

  def test_activate
    get :activate,
      :activation_code => '8f24789ae988411ccf33ab0c30fe9106fab32e9a'
    assert_response :redirect
  end

  def test_show
    get :show,
      :user_login => users(:quentin).login
    assert_response :success
  end

  def test_edit
    get :edit,
      :user_login => users(:quentin).login
    assert_response :success
  end

  def test_update
    put :update,
      :user_login => users(:quentin).login,
      :user => {
      :first_name => 'John',
      :surname => 'Grimes',
      'date_of_birth(1i)' => '1983',
      'date_of_birth(2i)' => '6',
      'date_of_birth(3i)' => '21',
      :gender => 'male',
      :home_town => 'Gold Coast, Australia',
      :about_me => 'I am cool.',
      :fave_travel_experience => 'Riding on a double decker bus.',
      :languages => 'English, Japanese, German' }
    assert_response :success
  end

  def test_upload_picture
    get :upload_picture,
      :user_login => users(:quentin).login
    assert_response :success
  end

  def test_update_picture
    picture_data = uploaded_file("#{File.expand_path(RAILS_ROOT)}/test/fixtures/sample_picture.jpg", "image/jpeg")
    put :update_picture,
      :user_login => users(:quentin).login,
      :picture => picture_data
    assert_response :success
  end

  def test_get_profile_pic
    get :get_profile_pic,
      :user_login => users(:quentin).login,
      :format => 'tiny'
    assert_response :success
  end

  # END User Action Tests

  # START User Defect Tests

  def test_show_nonexistent_user
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show,
      :user_login => 'roger'
    }
  end

  def test_get_nonexistent_profile_pic
    assert_raise(ActiveRecord::RecordNotFound) {
      get :get_profile_pic,
      :user_login => 'roger',
      :format => 'tiny'
    }
  end

  def test_show_user_not_logged_in
    logout
    get :show,
      :user_login => users(:aaron).login
    assert_response :success
    login_as :quentin
  end

  def test_edit_user_not_logged_in
    logout
    get :edit,
      :user_login => users(:quentin).login
    assert_redirected_to :controller => 'sessions', :action => 'new'
    login_as :quentin
  end

  def test_edit_user_not_you
    get :edit,
      :user_login => users(:aaron).login
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  def test_update_user_not_logged_in
    logout
    put :update,
      :user_login => users(:quentin).login,
      :user => {
      :first_name => 'John',
      :surname => 'Grimes',
      'date_of_birth(1i)' => '1983',
      'date_of_birth(2i)' => '6',
      'date_of_birth(3i)' => '21',
      :gender => 'male',
      :home_town => 'Gold Coast, Australia',
      :about_me => 'I am cool.',
      :fave_travel_experience => 'Riding on a double decker bus.',
      :languages => 'English, Japanese, German' }
    assert_redirected_to :controller => 'sessions', :action => 'new'
    login_as :quentin
  end

  def test_update_user_not_you
    put :update,
      :user_login => users(:aaron).login,
      :user => {
      :first_name => 'John',
      :surname => 'Grimes',
      'date_of_birth(1i)' => '1983',
      'date_of_birth(2i)' => '6',
      'date_of_birth(3i)' => '21',
      :gender => 'male',
      :home_town => 'Gold Coast, Australia',
      :about_me => 'I am cool.',
      :fave_travel_experience => 'Riding on a double decker bus.',
      :languages => 'English, Japanese, German' }
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  def test_upload_picture_not_logged_in
    logout
    get :upload_picture,
      :user_login => users(:quentin).login
    assert_redirected_to :controller => 'sessions', :action => 'new'
    login_as :quentin
  end

  def test_upload_picture_not_you
    get :upload_picture,
      :user_login => users(:aaron).login
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  def test_update_picture_not_logged_in
    logout
    picture_data = uploaded_file("#{File.expand_path(RAILS_ROOT)}/test/fixtures/sample_picture.jpg", "image/jpeg")
    put :update_picture,
      :user_login => users(:quentin).login,
      :picture => picture_data
    assert_redirected_to :controller => 'sessions', :action => 'new'
    login_as :quentin
  end

  def test_update_picture_not_you
    picture_data = uploaded_file("#{File.expand_path(RAILS_ROOT)}/test/fixtures/sample_picture.jpg", "image/jpeg")
    put :update_picture,
      :user_login => users(:aaron).login,
      :picture => picture_data
    assert_redirected_to :controller => 'sessions', :action => 'new'
  end

  # END User Defect Tests

  protected
  def create_user(options = {})
    post :create, :user => { :login => 'quire', :email => 'test_quire@blavel.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
