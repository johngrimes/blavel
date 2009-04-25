class MaileesController < ApplicationController
  layout 'standard', :only => [ :show ]
  before_filter :login_required
  
  # Responds with a users' mailee list, and a form to send the specified post
  # to those mailees.
  # Parameters:: post_id
  # Route:: /posts/:post_id/mailing
  def show
    
    # Get specified post, checking that it exists
    @post = Post.find(params[:post_id])
    @user = @post.user
    
    # Check that the current user is the owner of the specified post, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You must be logged in as the owner in order to view a mailing list.'
      redirect_to :controller => 'sessions', :action => 'new'
    end
    
    # Pass through mailees in alphabetical order
    @mailees = Mailee.find_all_by_user_id(@user.id, :order => 'email')
  end
  
  # Adds a new mailee to the specified user's mailing list.
  # Parameters:: user_login, add_mailee, post_id
  # Route:: POST /:user_login/mailees
  def add
    
    # Get specified user
    @user = User.find_by_login(params[:user_login])
    
    # Check that the current user is the owner of the specified post, or an
    # administrator
    unless @user == current_user or admin_logged_in?
      flash[:error] = 'You must be logged in as the owner in order to change a mailing list.'
      redirect_to :controller => 'sessions', :action => 'new'
    end
    
    # Create new mailee and save, redirecting back to show mailees action
    @mailee = Mailee.new
    @mailee.user = @user
    @mailee.email = params[:add_mailee]
    if @mailee.save!
      flash[:notice] = "The email address #{@mailee.email} was added to your mailing list."
      redirect_to :action => 'show', :post_id => params[:post_id]
    end
  end
  
  # Removes a mailee from the specified user's mailing list.
  # Parameters:: user_login, remove_mailee, post_id
  # Route:: DELETE /:user_login/mailees
  def destroy
    
    # Get specified mailess
    @mailee = Mailee.find(params[:remove_mailee])
    
    # Check that the current user is the owner of the specified post, or an
    # administrator
    unless @mailee.user == current_user or admin_logged_in?
      flash[:error] = 'You must be logged in as the owner in order to change a mailing list.'
      redirect_to :controller => 'sessions', :action => 'new'
    end
    
    # Destroy mailee, redirecting to show mailees action
    removed_email = @mailee.email
    if @mailee.destroy
      flash[:notice] = "The email address #{removed_email} was removed from your mailing list."
      redirect_to :action => 'show', :post_id => params[:post_id]
    end
  end
  
  # Send a post noticiation email to selected mailees from a user's mailing 
  # list.
  # Parameters:: post_id, to_send
  # Route:: POST /posts/:post_id/mailing
  def send_to
    
    # Get specified post, checking that it exists
    @post = Post.find(params[:post_id])
    
    if params[:to_send]
      @mailees = []
      
      # Find each mailee specified in the to_send parameter
      params[:to_send].each do |m|
        @mailees.push Mailee.find(m)
      end
      
      # Deliver emails to each of the mailees, with a maximum of 10 recipients
      # for each email
      chunk(@mailees, 10).each do |mailee_chunk|
        UserMailer.deliver_mailing_list(@post, mailee_chunk)
      end
    end
    
    # Redirect back to show mailees action
    flash[:notice] = "Your post was emailed to the selected emails on your mailing list."
    redirect_to :action => 'show'
  end
end
