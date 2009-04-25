class FacebookController < ApplicationController
  layout 'facebook'
  before_filter :ensure_authenticated_to_facebook
  skip_before_filter :ensure_authenticated_to_facebook,
    :only => [:tab, :instructions]
  
  # Responds with a page summarising the last 5 posts that a Blavel user has 
  # made.
  # Route:: GET /facebook
  def index  
    # Get facebook and blavel users from facebook session
    @facebook_user = facebook_session.user
    @fb_link = FacebookUser.for(@facebook_user.to_i)
    
    # If blavel user has linked to facebook, pass through last 5 posts
    # Otherwise, redirect to facebook link action
    if @fb_link
      @blavel_user = User.find(@fb_link.user_id)
      @posts = Post.find_all_by_user_id(@blavel_user.id, 
        :order => 'created_at desc', 
        :limit => 5)
      render :template => 'facebook/index.fbml.erb'
    else
      redirect_to $FACEBOOK_APP_BASE + '/link'
    end
  end
  
  # Responds with a Facebook profile tab summarising the last 5 posts that a 
  # Blavel user has made.
  # Parameters:: fb_sig_profile_user
  # Route:: GET /facebook/tab
  def tab
    # Get facebook and blavel users for viewed profile owner
    @fb_link = FacebookUser.for(params[:fb_sig_profile_user])
    
    # If blavel user has linked to facebook, pass through last 5 posts
    # Otherwise, point out that user has not linked their accounts
    if @fb_link
      @blavel_user = User.find(@fb_link.user_id)
      @posts = Post.find_all_by_user_id(@blavel_user.id, 
        :order => 'created_at desc', 
        :limit => 5)
      @facebook_user = params[:fb_sig_profile_user]
      render(:partial => 'facebook_publisher/profile')
    else
      render :text => 'Link not found between Blavel and this Facebook user.'
    end
  end
  
  # Responds with a form to link your Blavel account to your Facebook account.
  # Route:: GET /facebook/link
  def new_link
    render :template => 'facebook/new_link.fbml.erb'
  end
  
  # Creates a link between a users' Blavel account and their Facebook account.
  # Parameters:: login, password
  # Route:: POST /facebook/link
  def create_link
    # Authenticate blavel login
    if User.authenticate(params[:login], params[:password])
      @user = User.find_by_login(params[:login])
      
      # Create and save new link, including facebook session key
      @new_link = FacebookUser.new
      @new_link.user_id = @user.id
      @new_link.facebook_id = facebook_session.user
      @new_link.session_key = facebook_session.session_key
      @new_link.save
      
      # Flash success message and redirect to facebook offline access
      # authorisation form
      flash[:notice] = 'Your Blavel account is now linked to your Facebook account.<br/>
      You now have the option to add a \'My Blavel\' tab and/or profile box to your Facebook. Click <a href="http://www.blavel.com/help/facebook" target="_blank">here</a> for instructions on how to do this.<br/>
      Also, whenever you post from now on, a news item will show up on your wall announcing your new post.'
      redirect_to "http://www.facebook.com/authorize.php?api_key=#{$FACEBOOK_API_KEY}&v=1.0&ext_perm=offline_access&next=#{$FACEBOOK_APP_BASE}/&next_cancel=#{$FACEBOOK_APP_BASE}/"
    else
      flash[:error] = 'Your login was unsuccessful. Please check your details and try again.'
      redirect_to $FACEBOOK_APP_BASE + '/'
    end
  end
end
