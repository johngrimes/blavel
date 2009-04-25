# Includes required for legacy migration rake tasks
require 'legacy_migration/abstract_legacy_record'
require 'legacy_migration/legacy_mailee'
require 'legacy_migration/legacy_note'
require 'legacy_migration/legacy_picture'
require 'legacy_migration/legacy_post'
require 'legacy_migration/legacy_user'

class ApplicationController < ActionController::Base
  include GeneralUtilities, AuthenticatedSystem, ExceptionNotifiable
  helper GeneralUtilities, :all
  
  # Required to make swfupload_session_hack.rb work.
  # Is apparently a slight security risk.
  session :cookie_only => false
  
  before_filter :set_utf
  
  # Filter to set all responses to UTF-8 HTML by default.
  def set_utf
    headers['Content-Type'] = 'text/html; charset=UTF-8'
  end
  
  before_filter :set_time_zone
  
  # If a user is logged in, sets the time zone to the user's stored preference.
  def set_time_zone
    if logged_in?
      Time.zone = current_user.time_zone
    end
  end
  
  def local_request?
    false
  end
end