class Picture < ActiveRecord::Base
  include ActionController::UrlWriter
  
  belongs_to :post
  belongs_to :location
  has_many :notes
  has_attachment  :storage => :s3,
    :max_size => 20.megabytes,
    :content_type => :image,
    :thumbnails => { :display => '600x600>', :small => '200x200>', :tiny => '100x100>' },
    :processor => :MiniMagick
  
  validates_length_of :title, :maximum => 100, :allow_nil => true
  
  after_create :update_facebook_profile, :refresh_facebook_cache
    
  # Update of Facebook profile, triggered after creation of a picture.
  def update_facebook_profile
    
    # Only update profile if the owner of the post this picture is attached to 
    # has linked their facebook account 
    # Also never publish to Facebook from the development environment
    if RAILS_ENV != 'development' && post && post.user.facebook_user
      begin
        FacebookPublisher.deliver_profile_update(post.user)
      rescue Exception => exception
        AdminMailer.deliver_error(exception)
      end
    end
  end
  
  # Refresh of cached copy of images in Facebook profile, triggered after 
  # creation of a picture.
  def refresh_facebook_cache
    
    # Only update profile if the owner of the post this picture is attached to 
    # has linked their facebook account 
    # Also never update Facebook from the development environment
    if RAILS_ENV != 'development' && post && fb_user = post.user.facebook_user
      
      # Refresh facebook session
      fb_session = fb_user.facebook_session
      begin
        
        # Call facebook api to refresh image with the url of this picture
        fb_session.server_cache.refresh_img_src(public_filename(:tiny))
      rescue Exception => exception
        AdminMailer.deliver_error(exception)
      end
    end
  end
end
