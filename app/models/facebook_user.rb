class FacebookUser < ActiveRecord::Base
  belongs_to :user
  
  after_create :update_facebook_profile
  
  # Returns the corresponding FacebookUser object, given a Facebook ID.
  def self.for(facebook_id)
    return find_by_facebook_id(facebook_id)
  end
  
  # Updates the session key for this FacebookUser object, taking into account 
  # that the session key may not have changed
  def update_session_key(new_session_key)
    if session_key != new_session_key
      update_attribute(:session_key, new_session_key)
    end
  end
  
  # Refreshes the Facebook session and returns it.
  def facebook_session
    @facebook_session =
      returning Facebooker::Session.create do |session| 
      
      # Use stored session key to authenticate session with Facebook
      session.secure_with!(session_key, facebook_id, 1.day.from_now)
    end
    
    # Set the current session to this session
    Facebooker::Session.current = @facebook_session
    
    # Update the stored session key with any new key sent back by Facebook
    update_session_key(@facebook_session.session_key)
    
    # Return the fresh session
    return @facebook_session
  end
  
  # Updates the user's Facebook My Blavel profile box.
  def update_facebook_profile
    if user.facebook_user
      begin
        FacebookPublisher.deliver_profile_update(user)
      rescue Exception => exception
        AdminMailer.deliver_error(exception)
      end
    end
  end
end
