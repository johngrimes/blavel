module AuthenticatedSystem
  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    !!current_user
  end
    
  def admin_logged_in?
    logged_in? and current_user.admin
  end

  # Accesses the current user from the session. 
  # Future calls avoid the database because nil is not equal to false.
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end

  def login_required
    logged_in? || access_denied
  end
    
  def admin_login_required
    admin_logged_in? || admin_access_denied
  end

  # Redirect as appropriate when an access request fails.
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = 'You need to be logged in to do that.'
        redirect_to new_session_path
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
    
  # Redirect as appropriate when an access request fails.
  def admin_access_denied
    respond_to do |format|
      format.html do
        store_location
        flash[:error] = 'You need to be logged in as a Blavel administrator to do that.'
        redirect_to new_session_path
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end

  # Store the URI of the current request in the session.
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?, :admin_logged_in?
  end

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Called from #current_user.  Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    authenticate_with_http_basic do |username, password|
      self.current_user = User.authenticate(username, password)
    end
  end

  # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end
    
  def new_session_path
    url_for :controller => 'sessions', :action => 'new'
  end
end