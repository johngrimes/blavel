module FollowsHelper
  
  # Constructs a textual summary of a follow for use on a feed.
  def follow_feed_summary(follow, include_host = false)
    
    # Get user objects involved in follow
    follower = User.find(follow.follower_id)
    followee = User.find(follow.followee_id)
    
    # Create links for the names of users involved in follow, using 'you'
    # if the user is the currently logged in user
    # If include_host flag is set, add the full domain name and protocol to
    # the start of each link
    follower_link = link_to((current_user == follower ? 'You' : follower.login), 
      user_profile_url(:user_login => follower.login, :host => include_host ? $DEFAULT_HOST : nil))
    followee_link = link_to((current_user == followee ? 'you' : followee.login), 
      user_profile_url(:user_login => followee.login, :host => include_host ? $DEFAULT_HOST : nil))
    
    # Return full sentence
    "#{follower_link} started following #{followee_link}."
  end
end