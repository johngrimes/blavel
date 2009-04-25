class AdminMailer < ActionMailer::Base
  include GeneralUtilities

  # Defines the notification email sent to the Blavel administrator when
  # a user makes a new post.
  def post(post)
    @recipients = "Blavel Administrator <blavel@blavel.com>"
    @subject = "Post notification!"
    @from = "Blavel! <blavel@blavel.com>"
    @sent_on = Time.now
    @body[:post] = post
    @body[:url] = verbose_post_path(post, true)
  end

  # Defines the notification email sent to the Blavel administrator when
  # a user sends a message.
  def message(message)
    @recipients = "Blavel Administrator <blavel@blavel.com>"
    @subject = "Message notification!"
    @from = "Blavel! <blavel@blavel.com>"
    @sent_on = Time.now
    @body[:message] = message
  end

  # Defines the notification email sent to the Blavel administrator when an
  # uncaught exception occurs in Blavel.
  def error(exception)
    @recipients = "Blavel Administrator <blavel@blavel.com>"
    @subject = "Error notification!"
    @from = "Blavel! <blavel@blavel.com>"
    @sent_on = Time.now
    @body[:exception] = exception
  end
end
