class FollowsController < ApplicationController
  layout 'standard', :only => [ :show_all_followers, :show_all_followees ]
  before_filter :login_required, :only => [ :follow, :unfollow ]
  
  # Starts a user following another user, which brings updates about the
  # followed user into the following user's feed.
  # Parameters:: user_login
  # Route:: POST /:user_login/follow
  def follow
    
    # Get the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Create and save a new follow, with the current user as the follower
    follow = Follow.new
    follow.follower_id = current_user.id
    follow.followee_id = @user.id
    follow.save!
    
    # Send an email to the user being followed
    UserMailer.deliver_follow(current_user, @user)
    
    # Redirect back to the profile of the user being followed
    flash[:notice] = "You are now following #{@user.login}."
    redirect_to user_profile_url(:user_login => @user.login)
  end
  
  # Stops a user following another user.
  # Parameters:: user_login
  # Route:: DELETE /:user_login/unfollow
  def unfollow
    
    # Get the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Find the follow relationship between the current user and the specified
    # user
    @follow = Follow.find(:first, :conditions => "follower_id = #{current_user.id} and followee_id = #{@user.id}")
    
    # Destroy the follow relationship
    @follow.destroy
    current_user.save!
    
    # Redirect back to the profile of the user that was being followed
    flash[:notice] = "You are no longer following #{@user.login}."
    redirect_to user_profile_url(:user_login => @user.login)
  end
  
  # Responds with a page showing all of the users that are currently following
  # the specified user.
  # Parameters:: user_login
  # Route:: GET /:user_login/followers
  def show_all_followers
    
    # Get the specified user, making sure that it exists
    if !@user = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end
    
    # Pass through the set of users that are following the specified user
    @followers = @user.followers
  end
  
  # Responds with a page showing all of the users that the specified user is
  # currently following.
  # Parameters:: user_login
  # Route:: GET /:user_login/followees
  def show_all_followees
    
    # Get the specified user, making sure that it exists
    if !@user = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end
    
    # Pass through the set of users that are being followed by the specified 
    # user
    @followees = @user.followees
  end
end
