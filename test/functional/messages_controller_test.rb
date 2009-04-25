require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :users, :messages

  def setup
    login_as :quentin
  end

  # START Messages Action Tests

  def test_new
    get :new,
      :user_login => users(:aaron).login
    assert_response :success
  end

  def test_create
    assert_difference 'Message.count', +1 do
      post :create,
        :message => {
          :recipient_id => users(:aaron).id,
          :content => 'How are <strong>you</strong> going?' }
      assert_response :redirect
    end
  end

  def test_show
    get :show,
      :id => messages(:one).id
    assert_response :success
  end

  def test_manage
    get :manage
    assert_response :success
  end

  def test_convo
    @request.accept = 'text/javascript'
    get :convo,
      :id => messages(:one).id
    assert_response :success
    assert @response.content_type == 'text/javascript'
  end

  def test_mark_as_read
    @request.accept = 'text/javascript'
    post :mark_as_read,
      :id => messages(:two).id
    assert_response :success
    assert @response.content_type == 'text/javascript'
    assert Message.find(messages(:two).id).read == true
  end

  # END Messages Action Tests

  # START Messages Defect Tests

  def test_should_not_message_self
    assert_no_difference 'Message.count' do
      post :create,
        :message => {
          :recipient_id => users(:quentin).id,
          :content => 'How are <strong>you</strong> going?' }
      assert_response :redirect
    end
  end

  def test_show_nonexistent_message
    assert_raise(ActiveRecord::RecordNotFound) {
      get :show,
        :id => 99
    }
  end

  def test_outsider_view_private_message
    logout
    login_as :bruce
    get :show,
      :id => messages(:one).id
    assert_redirected_to :action => 'manage'
    login_as :quentin
  end

  # END Messages Defect Tests
end
