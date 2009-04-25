module NotesHelper
  
  # Constructs a textual summary of a note for use on a feed.
  def note_feed_summary(note, include_host = false)
    
    # Create a link for the name of the note leaver, using you if the note
    # leaver is the user currently logged in
    note_leaver_link = (current_user == note.user) ? 'You' : link_to(note.user.login, user_profile_url(:user_login => note.user.login, :host => include_host ? $DEFAULT_HOST : nil))
    
    subject = ''
    
    if note.post
      
      # Form a possessive word, which will either be your or user_login's
      # depending on whether the person who is logged in is the owner of the
      # post being noted
      possessive = (current_user == note.post.user) ? 'your' : link_to(note.post.user.login, user_profile_url(:user_login => note.post.user.login, :host => include_host ? $DEFAULT_HOST : nil)) + "'s"
      
      # Get the verbose url for the post
      post_url = verbose_post_path(note.post, include_host)
      
      # Use the post title or just 'post', depending on if the post has a title
      # or not
      if note.post.title.blank?
        subject = possessive + ' ' + link_to('post', post_url)
      else
        subject = possessive + ' post ' + link_to(note.post.title, post_url)
      end
      
    elsif note.picture
      
      # Form a possessive word, which will either be your or user_login's
      # depending on whether the person who is logged in is the owner of the
      # picture being noted
      possessive = (current_user == note.picture.post.user) ? 'you' : link_to(note.picture.post.user.login, user_profile_url(:user_login => note.picture.post.user.login, :host => include_host ? $DEFAULT_HOST : nil))
      
      # Get the url for the post
      picture_url = show_picture_url(:id => note.picture.id, :host => include_host ? $DEFAULT_HOST : nil)
      
      # Use the post title or just 'a picture', depending on if the picture has 
      # a title or not
      if note.picture.title.blank?
        subject = 'a ' + link_to('picture', picture_url) + ' from a post by ' + possessive
      else
        subject = 'the picture ' + link_to(note.picture.title, picture_url) + ' from a post by ' + possessive
      end
    end
    
    # String the elements together and return
    note_leaver_link + ' left a note on ' + subject + '.'
  end
end
