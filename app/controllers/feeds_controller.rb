class FeedsController < ApplicationController
  layout 'standard', :only => [ :feed ]

  # Responds with a feed summarising what has been happening on Blavel recently.
  # Parameters:: everybody
  # Route:: GET /feed/everybody or GET /
  def feed

    # If the user is not logged in, render the non-member home action
    if !current_user
      render :template => 'promo/home', :layout => 'empty'
    else
      @everybody = params[:everybody]

      # If the everybody flag is set, respond with feed items about everybody
      # on Blavel
      # Otherwise, respond with feed items only about the people that the
      # current user is following
      if @everybody
        @feed_items = gather_feed_items
      else
        @feed_items = gather_feed_items(current_user)
      end

      # Pass through the first 5 followers and the first 5 followees, all
      # randomised
      @followers = current_user.followers.sort_by { rand }.first(6)
      @followees = current_user.followees.sort_by { rand }.first(6)

      # Respond with html or javascript, depending on whether it is requested
      # via ajax or not
      respond_to do |format|
        format.html
        format.js { render :template => 'feeds/feed.js.erb', :layout => false }
      end
    end
  end

  # Responds with an RSS feed summarising what has been happening on Blavel
  # recently.
  # Parameters:: user_login, everybody
  # Route:: GET /:user_login/feed
  def rss

    # Get the specified user, making sure that it exists
    if !@user = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end

    # If the everybody flag is set, respond with feed items about everybody
    # on Blavel
    # Otherwise, respond with feed items only about the people that the
    # current user is following
    @everybody = params[:everybody]
    if @everybody
      @feed_items = gather_feed_items
    else
      @feed_items = gather_feed_items(current_user)
    end

  rescue ActiveRecord::RecordNotFound => error
    logger.info error
    flash[:notice] = 'The user you requested does not exist.'
    redirect_to '/'
  end

  private

  # Collects notes, posts and followings of interest to the specified user,
  # based on the list of users that the specified user is following.
  def gather_feed_items(user = nil)
    if user
      # Notes left on your posts and pictures
      notes_on_your_posts = []

      user.posts.each do |post|
        notes_on_your_posts = smush(notes_on_your_posts, post.notes)
        post.pictures.each do |picture|
          notes_on_your_posts = smush(notes_on_your_posts, picture.notes)
        end
      end

      # Notes left by people the current user is following
      notes_left_by_followees = []

      # Notes left on posts owned by people the current user is following
      notes_left_on_followees_posts = []

      # Notes left on pictures owned by people the current user is following
      notes_left_on_followees_pictures = []

      # Posts created by people the current user is following
      posts_by_followees = []

      # Followings of people the current user is following
      following_followees = []

      # People the current user is following, following other people
      followees_following = []

      user.followees.each do |followee|
        posts_by_followees = smush(posts_by_followees, followee.posts)
        notes_left_by_followees = smush(notes_left_by_followees, followee.notes)

        followee.posts.each do |post|
          notes_left_on_followees_posts = smush(notes_left_on_followees_posts, post.notes)
          post.pictures.each do |picture|
            notes_left_on_followees_pictures = smush(notes_left_on_followees_pictures, picture.notes)
          end
        end

        following_followees = smush(following_followees, Follow.find_all_by_followee_id(followee.id, :conditions => "follower_id <> #{user.id}"))
        followees_following = smush(followees_following, Follow.find_all_by_follower_id(followee.id, :conditions => "follower_id <> #{user.id}"))
      end

      # Remove totally blank posts from feed
      posts_by_followees.each do |post|
        if post.title.blank? and post.content.blank? and post.pictures.length == 0
          posts_by_followees.delete(post)
        end
      end
      blavel_posts = User.find_by_login('blavel') ? User.find_by_login('blavel').posts : nil
      posts = smush(posts_by_followees, blavel_posts)
      if posts
        posts = posts.uniq
      end

      # Remove notes left by logged in user
      notes = smush(notes_on_your_posts, notes_left_by_followees, notes_left_on_followees_posts, notes_left_on_followees_pictures)
      notes.each do |note|
        if note.user == user
          notes.delete(note)
        end
      end
      notes = notes.uniq

      # Add together follows
      following_you = Follow.find_all_by_followee_id(user.id)
      follows = smush(following_you, following_followees, followees_following)
      follows = follows.uniq
    else
      # If no user is specified, return all feed items
      notes = Note.find(:all)
      posts = Post.find(:all)
      follows = Follow.find(:all)

      # Remove totally blank posts from feed
      posts.each do |post|
        if post.title.blank? and post.content.blank? and post.pictures.length == 0
          posts.delete(post)
        end
      end
    end

    feed_items = smush(notes, posts, follows)
    feed_items.sort! { |x,y| y.created_at <=> x.created_at }
    feed_items = feed_items[0..19]

    return feed_items
  end
end
