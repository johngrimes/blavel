class FacebookPublisher < Facebooker::Rails::Publisher
  helper PostsHelper, LocationsHelper, PicturesHelper, GeneralUtilities
  
  # Defines the template for the feed item that is posted on a user's wall
  # when they create a new post.
  def post_feed_template
    one_line_story_template "{*actor*} made a new {*title*} on Blavel."
  end
  
  # Defines how a update to a user's My Blavel profile box is published.
  def profile_update(user)
    send_as :profile
    recipients user.facebook_user.facebook_session.user
    profile render(:partial => 'facebook_publisher/profile', 
      :assigns => { :posts => Post.find_all_by_user_id(user.id, :order => 'created_at desc', :limit => 5),
        :blavel_user => user,
        :facebook_user => user.facebook_user.facebook_session.user })
  end
  
  # Defines how an update to a user's wall is published when they create a new 
  # post.
  def post_feed(post)
    pictures = Picture.find_all_by_post_id(post.id, :order => 'sequence', :limit => 3)
    images = []
    pictures.each do |picture|
      images.push image(get_picture_file_url(:id => picture.id, :format => 'tiny', :host => $DEFAULT_HOST), show_picture_url(:id => picture.id, :host => $DEFAULT_HOST))
    end
    send_as :user_action
    from post.user.facebook_user.facebook_session.user
    data :title => post.title.blank? ? link_to('post', verbose_post_path(post, true)) : "post titled '#{link_to(post.title, verbose_post_path(post, true))}'",
      :images => images
  end
end
