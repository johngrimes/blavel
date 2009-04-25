class PostsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  
  layout 'standard'
  before_filter :login_required, :only => [ :new, :create, :edit, :update, :destroy ]
  
  # Displays the specified post.
  # Parameters:: id
  # Route:: GET /travel-blogs/:id
  def show
    # Pass through specified post, making sure it exists
    @post = Post.find(params[:id])
    
    # If the post has no content, but has more than one picture, use the show
    # all pictures action as the default for this post
    if @post.content.blank? && !@post.pictures.empty?
      if @post.pictures.length == 1
        redirect_to :controller => 'pictures', :action => 'show', :id => @post.pictures.first.id
      else
        redirect_to :controller => 'pictures', :action => 'show_all', :post_id => @post.id
      end
    end
  end

  # Responds with a form to create a new post.
  # Route:: GET /posts/new
  def new
    
    # Create a new post
    @post = Post.new
    
    # Use the same template as for editing a post, except set the new_post flag
    # to true
    @new_post = true
    render :template => 'posts/edit'
  end

  # Responds with a form to edit an existing post.
  # Parameters:: id
  # Route:: GET /posts/:id/edit
  def edit
    
    # Pass through the specified post, making sure it exists
    @post = Post.find(params[:id])
    
    # Check that the current user is the owner of the specified post, or an
    # administrator
    unless @post.user == current_user or admin_logged_in?
      flash[:error] = 'You must be logged in as the owner in order to edit a post.'
      redirect_to :controller => 'sessions', :action => 'new'
    end
  end

  # Creates a new post.
  # Parameters:: post[title, content, location_ids[]]
  # Route:: POST /posts
  def create
    
    # Remove any disallowed tags from post content
    params[:post][:content] = sanitize(params[:post][:content], :tags => %w(strong em strike ul ol li a br p))
    
    # Create a new post with the supplied data
    @post = Post.new(params[:post])
    
    # Set the owner of the post to the current authenticated user
    @post.user = current_user
    
    # Save the post and redirect back to the edit action
    if @post.save!
      flash[:notice] = 'Your new post was created.'
      redirect_to :action => 'edit', :id => @post.id
    end
  end

  # Updates the title, content and location tags of an existing post.
  # Parameters:: post[title, content, location_ids[]]
  # Route:: PUT /posts/:id
  def update
    
    # Pass through the specified post, making sure it exists
    @post = Post.find(params[:id])
    
    # Remove any disallowed tags from post content
    params[:post][:content] = sanitize(params[:post][:content], :tags => %w(strong em strike ul ol li a br p))
    
    # Check that logged in user is owner or administrator
    unless @post.user == current_user or admin_logged_in?
      flash[:error] = 'You must be logged in as the owner in order to update a post.'
      redirect_to :controller => 'sessions', :action => 'new'
    end
    
    # Update post and redirect to edit post action
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Your post was updated.'
      redirect_to :action => 'edit', :id => @post.id
    end
  end

  # Removes a specified post.
  # Parameters:: id
  # Route:: DELETE /posts/:id
  def destroy
    
    # Get specified post, making sure it exists
    @post = Post.find(params[:id])
    
    # Remove notes attached to pictures from this post
    @post.pictures.each do |picture|
      Note.destroy_all(:picture_id => picture.id)
    end
    
    # Remove pictures attached to this post
    Picture.destroy_all(:post_id => params[:id])
    
    # Remove notes attached to this post
    Note.destroy_all(:post_id => params[:id])
    
    # Remove post and redirect to owner's profile action
    if @post.destroy
      flash[:notice] = 'Your post has been removed.'
      redirect_to user_profile_url(:user_login => current_user.login)
    end
  end
end
