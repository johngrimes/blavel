class UserMailer < ActionMailer::Base
  include GeneralUtilities

  # Defines the activation email sent to a user after first joining.
  def activate(user)
    @recipients  = "#{user.login} <#{user.email}>"
    @bcc         = "blavel@blavel.com"
    @from        = "Blavel! <feedback@blavel.com>"
    @sent_on     = Time.now
    @subject     = 'Activate your Blavel!'
    @body[:user] = user
    @body[:url]  = activate_url(:activation_code => user.activation_code, :host => $DEFAULT_HOST)
  end

  # Defines the welcome email sent to a user after they have activated their
  # account.
  def just_joined(user)
    @recipients  = "#{user.login} <#{user.email}>"
    @bcc         = "blavel@blavel.com"
    @from        = "Blavel! <feedback@blavel.com>"
    @sent_on     = Time.now
    @subject     = 'Getting started!'
    @body[:user] = user
    @body[:facebook_help_url] = help_url(:action => 'facebook', :host => $DEFAULT_HOST)
    @body[:profile_page_url]  = user_profile_url(:user_login => user.login, :host => $DEFAULT_HOST)
  end

  # Defines the email that is sent to people that a user chooses to notify
  # about their post through the mailing list functionality.
  def mailing_list(post, mailees)
    @recipients = "Special Blavel People! <blavel@blavel.com>"
    @bcc = []
    mailees.each do |m|
      @bcc.push m.email
    end
    @subject = "#{post.user.login} posted a new Blavel!"
    @from = "Blavel! <feedback@blavel.com>"
    @sent_on = Time.now
    @body[:post] = post
    @body[:post_path] = verbose_post_path(post, true)
  end

  # Defines the notification email a user gets when another user leaves a note
  # on one of their posts or pictures.
  def note(note)
    if note.post
      note_recipient = note.post.user
      noted_item = note.post
      url = verbose_post_path(note.post, true)
    else
      note_recipient = note.picture.post.user
      noted_item = note.picture
      url = show_picture_url(:id => note.picture.id, :host => $DEFAULT_HOST)
    end

    @recipients = "#{note_recipient.login} <#{note_recipient.email}>"
    @bcc = "blavel@blavel.com"
    @subject = "#{note.user.login} left a note on your blavel!"
    @from = "Blavel! <feedback@blavel.com>"
    @sent_on = Time.now
    @body[:note] = note
    @body[:note_recipient] = note_recipient
    @body[:noted_item] = noted_item
    @body[:url] = url
  end

  # Defines the notification email a user gets when another user starts
  # following them.
  def follow(follower, followee)
    @recipients  = "#{followee.login} <#{followee.email}>"
    @bcc         = "blavel@blavel.com"
    @from        = "Blavel! <feedback@blavel.com>"
    @sent_on     = Time.now
    @subject     = "#{follower.login} started following you!"
    @body[:follower] = follower
    @body[:followee] = followee
    @body[:follower_profile_url] = user_profile_url(:user_login => follower.login, :host => $DEFAULT_HOST)
    @body[:follower_follow_url] = follow_url(:user_login => follower.login, :host => $DEFAULT_HOST)
  end

  # Defines the notification email a user gets when another user sends them a
  # private message.
  def message(message)
    @recipients  = "#{message.recipient.login} <#{message.recipient.email}>"
    @bcc         = "blavel@blavel.com"
    @from        = "Blavel! <feedback@blavel.com>"
    @sent_on     = Time.now
    @subject     = 'New message!'
    @body[:message] = message
    @body[:message_url] = show_message_url(:id => message.id, :host => $DEFAULT_HOST)
  end
end
