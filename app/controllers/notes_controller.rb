class NotesController < ApplicationController
  before_filter :login_required

  # Creates a new note on a post or a picture.
  # Parameters:: post_id, picture_id, content
  # Route:: POST /posts/:post_id/note or POST /pictures/:picture_id/note
  def create
    # Create a new note
    @note = Note.new

    # Get the post or picture, make sure it exists, and grab the url for that
    # post or picture
    if params[:post_id]
      @post = Post.find(params[:post_id])
      @note.post = @post
      next_url = verbose_post_path(@post)
    elsif params[:picture_id]
      @picture = Picture.find(params[:picture_id])
      @note.picture = @picture
      next_url = show_picture_url(:id => @picture.id)
    end

    # Set attributes and save note
    @note.user = current_user
    @note.content = params[:content]
    @note.save!

    # If the note leaver is not the owner, send a notification email to the
    # post or picture owner
    owner = @note.post ? @note.post.user : @note.picture.post.user
    if @note.user != owner
      UserMailer.deliver_note(@note)
    end

    # Redirect back to post or picture url
    flash[:notice] = 'Your note has been created.'
    redirect_to next_url
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "There is no such post or picture to leave a note on."
    redirect_to '/'
  end

  # Removes a note from a post or picture.
  # Parameters:: id
  # Route:: DELETE /notes/:id/remove
  def destroy
    # Get the specified note and make sure it exists
    @note = Note.find(params[:id])

    # Check that the current user is:
    # * the person who wrote the note
    # * the owner of the post or picture that the note was left on
    # * an administrator
    if admin_logged_in? or (logged_in? and @note.user == current_user) or (logged_in? and @note.post and @note.post.user == current_user) or (logged_in? and @note.picture and @note.picture.post.user == current_user)

      # Destroy note and redirect to the url of the post or picture that it
      # was left on.
      @note.destroy
      flash[:notice] = 'Your note has been removed.'
      if (@note.post)
        redirect_to verbose_post_path(@note.post)
      elsif (@note.picture)
        redirect_to show_picture_url(:id => @note.picture.id)
      end
    end
  end
end
