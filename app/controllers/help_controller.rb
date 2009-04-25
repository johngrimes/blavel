class HelpController < ApplicationController
  layout 'standard'

  # Responds with help page for linking your account to Facebook.
  # Route:: /help/facebook
  def facebook
  end

  # Responds with help page for uploading pictures to Blavel.
  # Route:: /help/uploading_pictures
  def uploading_pictures
  end

  # Responds with help page for private messaging.
  # Route:: /help/messaging
  def messaging
  end
end
