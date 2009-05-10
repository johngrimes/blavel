class PicturesController < ApplicationController
  layout 'standard', :only => [ :show, :show_all, :add, :edit ]
  before_filter :login_required, :only => [ :add, :edit, :update, :destroy ]

  # Responds with a picture file of a specified size.
  # Parameters:: id, format
  # Route:: GET /pictures/:id/:format
  def get_file
    if params[:format] == 'original'

      # If the original format is requested, get the picture with the id
      # requested, checking that it exists
      @picture = Picture.find(params[:id])
    else

      # If a different format other than original is requested, find the child
      # record of the requested id with the matching format, checking that it
      # exists
      if !@picture = Picture.find_by_parent_id(params[:id], :conditions => [ "thumbnail = ?", params[:format] ])
        raise ActiveRecord::RecordNotFound
      end
    end

    # Work out directory numbers for picture
    dir_1 = (params[:id].to_i / 10000) % 10000
    dir_2 = (params[:id].to_i % 10000)

    # Send the picture file with a mime type of image/jpeg
    send_file "#{RAILS_ROOT}/public/pictures/#{dir_1.to_s.rjust(4, '0')}/#{dir_2.to_s.rjust(4, '0')}/#{@picture.filename}",
      :type => 'image/jpeg'
  end

  # Displays a specified picture.
  # Parameters:: id
  # Route:: GET /pictures/:id
  def show

    # Pass through the specified picture, checking that it exists
    @picture = Picture.find(params[:id])

    # Make sure that all pictures are attached to a post
    if !@picture.post
      raise ActiveRecord::RecordNotFound
    end
  end

  # Displays all pictures from a specified post.
  # Parameters:: post_id
  # Route:: GET /posts/:post_id/pictures
  def show_all

    # Get the specified post, making sure that it exists
    @post = Post.find(params[:post_id])

    # Pass through all pictures from the specified post
    @pictures = @post.pictures
  end

  # Responds with a form to add new pictures to an existing post, or to a post
  # that has not been created yet.
  # Parameters:: post_id, new_post
  # Route:: GET /posts/:post_id/pictures/add or GET /posts/new/pictures/add
  def add

    if params[:post_id]

      # If adding to an existing post, make sure that post exists and pass it
      # through
      @post = Post.find(params[:post_id])
    else

      # Otherwise, create a new post and pass that through
      @post = Post.new
      @post.user = current_user
      @post.save!
    end
  end

  # Responds with a form to edit picture titles, descriptions and locations
  # for all pictures from a specified post.
  # Parameters:: post_id
  # Route:: GET /posts/:post_id/pictures/edit
  def edit

    # Make sure the specified post exists and pass it through
    @post = Post.find(params[:post_id])

    # Pass through all pictures attached to the specified post, in sequence
    # order
    @pictures = Picture.find_all_by_post_id(params[:post_id], :order => 'sequence')
  end

  # Creates a new picture and attaches it to the specified post. Requires the
  # passing of username and encrypted password, to allow Flash clients to create
  # pictures without having a valid session.
  # Parameters:: picture, post_id, ugly (login), goblin (password)
  # Route:: POST /posts/:post_id/pictures
  def create

    # Get specified user, making sure that it exists
    post_owner = User.find(params[:ugly])

    # Check that crypted password sent through is correct
    if post_owner.crypted_password != params[:goblin]
      raise Exception.new, 'You must be logged in to upload a picture.'
    end

    # Get specified post, making sure that it exists
    @post = Post.find(params[:post_id])

    # Check that user credentials match owner of post
    if post_owner != @post.user
      raise Exception.new, 'You must be the owner of a post to add pictures to it.'
    end

    # Create new picture and populate data
    @picture = Picture.new
    @picture.post = @post
    @picture.uploaded_data = params[:picture]
    @picture.content_type = 'image/jpeg'

    # Select appropriate sequence number based on any existing pictures already
    # attached to the post
    if !@post.pictures or @post.pictures.empty?
      @picture.sequence = 1
    else
      result = Picture.connection.select_all("SELECT MAX(sequence) AS last_number FROM pictures WHERE post_id = #{@post.id}")
      @picture.sequence = result[0]['last_number'].to_i + 1
    end

    # Save new picture and respond
    @picture.save!
  rescue Exception => error
    @error = error
    logger.error error
  ensure
    render :template => 'pictures/create.json.erb'
  end

  # Updates the title, description and location of all pictures attached to a
  # specified post.
  # Parameters:: post_id, picture[id, data[title, description, location_id, sequence]]
  # Route:: PUT /posts/:post_id/pictures
  def update

    # Get specified post, making sure it exists
    post = Post.find(params[:post_id])

    params[:picture].each do |id, data|

      # Set any empty location_ids in the picture data to NULL
      if data['location'] == nil || data['location'] == ''
        data['location'] = 'NULL'
      end

      # Escape single quotes in titles and descriptions
      data['title'] = data['title'].gsub(/'/, "&#39;")
      data['description'] = data['description'].gsub(/'/, "&#39;")

      # Update picture
      Picture.connection.update("UPDATE pictures
                                 SET title = '#{data['title']}',
                                 description = '#{data['description']}',
                                 location_id = #{data['location']},
                                 sequence = #{data['sequence']}
                                 WHERE id = #{id} LIMIT 1")
    end

    # Update facebook profile, as sequence changes may have changed the leading
    # thumbnail on the post summary
    post.update_facebook_profile

    # Redirect back to edit pictures action
    flash[:notice] = 'Your pictures were updated.'
    redirect_to edit_pictures_url(:post_id => params[:post_id])
  end

  # Removes a specified picture.
  # Parameters:: id
  # Route:: DELETE /pictures/:id
  def destroy
    # Get the specified picture, making sure it exists
    @picture = Picture.find(params[:id])
    @post_id = @picture.post_id

    # Resequence pictures in post
    after_pictures = Picture.find_all_by_post_id(@post_id, :conditions => "sequence > #{@picture.sequence}")
    after_pictures.each do |picture|
      picture.sequence = picture.sequence - 1
      picture.save!
    end

    # Remove all notes attached to picture
    Note.destroy_all(:picture_id => @picture.id)

    # Destroy picture (including files in file system)
    @picture.destroy

    # Redirect back unless removed from show picture page
    flash[:notice] = 'Your picture was removed.'
    redirect_to edit_pictures_url(:post_id => @post_id)
  end
end
