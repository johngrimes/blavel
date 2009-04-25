class Post < ActiveRecord::Base
  include GeneralUtilities
  
  belongs_to :user
  has_many :pictures
  has_many :notes
  has_and_belongs_to_many :locations
  
  validates_presence_of :user
  validates_length_of :title, :maximum => 255, :allow_nil => true
  
  after_create :update_facebook_profile, :post_facebook_feed_item, :send_admin_post
  after_update :update_facebook_profile
  
  # Update of Facebook profile, triggered after creation or update of a post.
  def update_facebook_profile
    
    # Only update profile if the owner of this has linked their facebook account 
    # Also never update Facebook from the development environment
    if RAILS_ENV != 'development' && user.facebook_user
      begin
        FacebookPublisher.deliver_profile_update(user)
      rescue Exception => exception
        AdminMailer.deliver_error(exception)
      end
    end
  end
  
  # Post of feed item to user's Facebook wall, triggered by creation of a new 
  # post.
  def post_facebook_feed_item
    
    # Only update profile if the owner of this has linked their facebook account 
    # Also never update Facebook from the development environment
    if RAILS_ENV != 'development' && user.facebook_user
      begin
        FacebookPublisher.deliver_post_feed(self) rescue nil
      rescue Exception => exception
        AdminMailer.deliver_error(exception)
      end
    end
  end
  
  # Posts a notification email to the Blavel administrator, triggered by the 
  # creation of a new post.
  def send_admin_post
    AdminMailer.deliver_post(self)
  end
end
