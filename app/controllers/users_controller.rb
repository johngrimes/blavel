class UsersController < ApplicationController
  layout 'standard', :only => [ :new, :activation, :show, :feed ]
  before_filter :login_required, :only => [ :edit, :update, :upload_picture, :update_picture ]
  
  # Responds with a form to join Blavel, creating a new user.
  # Route:: GET /join
  def new
  end

  # Creates a new Blavel user.
  # Route:: POST /users
  def create
    
    # Remove any remember me cookies
    cookies.delete :auth_token
    
    # Create new user and populate with data
    @user = User.new(params[:user])
    
    # Check that captcha solution was correct
    if verify_recaptcha(@user)
      
      # Save new user
      if @user.save
        
        # Send activation email to user's email address
        UserMailer.deliver_activate(@user)
        
        # Redirect to activation instructions
        redirect_to :action => 'activation', :user_login => @user.login
      else
        
        # Create message containing any errors that occurred while trying to
        # create the new user
        flash[:error] = ''
        @user.errors.each do |attribute, message|
          flash[:error] += "<div>#{attribute.capitalize} #{message}.</div>"
        end
        
        # Redirect to new user action
        render :action => 'new', :layout => 'standard'
      end
    else
      flash[:error] = 'You failed the prove you are not a robot test.'
      render :action => 'new', :layout => 'standard'
    end
  end
  
  # Responds with instructions on how to activate a new Blavel account.
  # Parameters:: user_login
  # Route:: GET :user_login/activate
  def activation
    @user = User.find_by_login(params[:user_login])
  end

  # Activates a new user account using an activation code.
  # Parameters:: activation_code
  # Route:: GET /activate/:activation_code
  def activate
    
    # If the activation code is not blank, look for a user with a matching
    # code and set that as the current_user
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    
    if current_user and !current_user.active?
      
      # If the current user is not already active, activate it
      current_user.activate
      
      # Send a just joined email to the user's email address
      UserMailer.deliver_just_joined(current_user)
      
      # Display a message on the next page indicating success
      flash[:notice] = 'Your account has been activated, and you have been logged in.<br/><br/>
      Facebook user? <br/><a href="/help/facebook" target="_blank">Connect your Facebook account</a> to Blavel to keep your friends updated.'
    else
      logger.info 'Invalid activation code provided.'
      flash[:error] = 'That activation code has either already been used, or it never existed.'
    end
    redirect_to '/'
  end
  
  # Responds with the profile page for a specified user.
  # Parameters:: user_login, page
  # Route:: GET /:user_login
  def show
    
    # Pass through the specified user, making sure that it exists
    if !@user = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end
    
    # Pass through all posts by the specified user, except for empty ones
    @posts = Post.paginate(:page => params[:page], 
      :conditions => empty_post_filter + " and user_id = #{@user.id}",
      :order => 'created_at DESC', :per_page => 5)
  end
  
  # Responds with a form to edit the profile details of a specified user.
  # Parameters:: user_login
  # Route:: GET /:user_login/edit
  def edit
    
    # Pass through the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Check that the current user is the specified user, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You cannot edit the profile of another user.'
      redirect_to :controller => 'sessions', :action => 'new'
    else
      render :layout => 'dialog'
    end
  end
  
  # Updates the profile details of the specified user.
  # Parameters:: user_login, user[first_name, surname, gender, date_of_birth(1i), date_or_birth(2i), date_of_birth(3i), home_town, about_me, fave_travel_experience, languages, time_zone], back_home
  # Route:: PUT /:user_login/edit
  def update
    
    # Get the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Check that the current user is the specified user, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You cannot update the profile of another user.'
      redirect_to :controller => 'sessions', :action => 'new'
    else
      
      # Update the details of the specified user
      @user.update_attributes(params[:user])
      
      # If back_home flag is set, redirect home (used for the case of 
      # prompting the user to update their time zone from the home page)
      if params[:back_home].blank?
        flash.now[:just_submitted] = true
        render :template => 'users/edit', :layout => 'dialog'
      else
        flash[:notice] = "Your time zone has been set to #{current_user.time_zone}."
        redirect_to '/'
      end
    end
  end
  
  # Responds with a form to upload a user profile picture for a specified user.
  # Parameters:: user_login
  # Route:: GET /:user_login/picture/upload
  def upload_picture
    
    # Pass through the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Check that the current user is the specified user, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You cannot upload a profile picture for another user.'
      redirect_to :controller => 'sessions', :action => 'new'
    else
      render :layout => 'dialog'
    end
  end
  
  # Updates the user profile picture for the specified user.
  # Parameters:: user_login, picture
  # Route:: PUT /:user_login/picture/upload
  def update_picture
    
    # Get the specified user, making sure that it exists
    @user = User.find_by_login(params[:user_login])
    
    # Check that the current user is the specified user, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You cannot upload a profile picture for another user.'
      redirect_to :controller => 'sessions', :action => 'new'
    else
      
      # Destroy any profile pictures currently associated with the 
      # specified user
      destroy_user_profile_pics(@user)   
      
      # Create a new profile picture and populate it with data
      @picture = ProfilePicture.new
      @picture.user = @user
      @picture.uploaded_data = params[:picture]
      @picture.content_type = 'image/jpeg'
      
      # Save new profile picture and redirect back to upload picture action
      @picture.save!
      flash.now[:just_submitted] = true
      render :template => 'users/upload_picture', :layout => 'dialog'
    end
  end
  
  # Responds with a profile picture for a specified user, and of a specified
  # size.
  # Parameters:: user_login, format
  # Route:: GET /:user_login/profile-pic/:format
  def get_profile_pic
    
    # Get the specified user, making sure that it exists
    if !@user = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end
    
    # Find the parent picture, making sure it exists
    # This needs to be done even if the format is not original, because it is
    # needed to construct the picture url
    if !@parent_picture = ProfilePicture.find_by_user_id(@user.id)
      raise ActiveRecord::RecordNotFound
    end
     
    # If the format requested is original, return the parent picture
    # Otherwise, find the child picture of the appropriate format
    if params[:format] == 'original'
      @picture = @parent_picture
    else
      @picture = ProfilePicture.find_by_parent_id(@parent_picture.id, 
        :conditions => [ "thumbnail = ?", params[:format] ])
    end
    
    # Send the picture file with a mime type of image/jpeg
    send_file "#{RAILS_ROOT}/public/profile_pictures/0000/#{@parent_picture.id.to_s.rjust(4, '0')}/#{@picture.filename}",
      :type => 'image/jpeg'
  end
  
  private
  
  def destroy_user_profile_pics(user)
    parent_picture = ProfilePicture.find_by_user_id(user.id)
    if parent_picture
      child_pictures = ProfilePicture.find_all_by_parent_id(parent_picture.id)
      parent_picture.destroy
      child_pictures.each do |p| 
        p.destroy
      end
    end
  end
end
