# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'standard'
  
  # Responds with a login form to create a new user session.
  # Route:: GET /login
  def new
    
    # If the referer header is set, set to redirect upon login
    if !session[:return_to] && !request.referer.blank?
      session[:return_to] = request.referer
    end
  end

  # Creates a new user session.
  # Parameters:: login, password, remember_me
  # Route:: POST /login
  def create
    
    # Authenticate login and password and set current_user
    self.current_user = User.authenticate(params[:login], params[:password])
    
    if logged_in?
      
      # If user asked for remember me, set cookie
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      
      # Redirect to referer or back to home
      flash[:notice] = "Welcome back, #{current_user.login}!"
      redirect_back_or_default '/'
    else
      flash.now[:error] = 'Your login was unsuccessful. Please check your details and try again.'
      render :action => 'new'
    end
  end

  # Ends a user session.
  # Route:: GET /logout
  def destroy
    
    # If the referer header is set, set to redirect upon logout
    if !session[:return_to] && !request.referer.blank?
      session[:return_to] = request.referer
    end
    
    # Remove remember me cookie
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    
    # Clear session
    session[:user_id] = nil
    
    # Redirect to referer or back to home
    flash[:notice] = "You have been logged out."
    redirect_back_or_default '/'
  end
end
