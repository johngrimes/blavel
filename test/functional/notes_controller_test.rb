require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper
  fixtures :notes, :posts, :pictures

  def setup
    login_as :aaron
  end

  # START Notes Action Tests

  def test_create_on_post
    post :create,
      :post_id => posts(:by_quentin).id,
      :content => 'This is a test note from aaron...'
    assert_response :redirect
  end

  def test_create_on_picture
    post :create,
      :post_id => pictures(:by_quentin).id,
      :content => 'This is a test note from aaron...'
    assert_response :redirect
  end

  def test_destroy
    delete :destroy,
      :id => notes(:by_aaron).id
    assert_response :redirect
  end

  # END Notes Action Tests

  # START Notes Defect Tests

  def test_email_sent
    assert_difference 'ActionMailer::Base.deliveries.length', +1 do
      post :create,
        :post_id => posts(:by_quentin).id,
        :content => 'This is a test note from aaron...'
    end
  end

  def test_no_email_sent_when_owner_notes
    assert_no_difference 'ActionMailer::Base.deliveries.length' do
      logout
      login_as :quentin
      post :create,
        :post_id => posts(:by_quentin).id,
        :content => 'I am noting my own post!'
      logout
      login_as :aaron
    end
  end

  # END Notes Defect Tests
end
