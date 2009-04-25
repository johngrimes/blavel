# Email settings
ActionMailer::Base.smtp_settings = {
  :address => 'mail.blavel.com',
  :port => 25,
  :domain => 'blavel.com',
  :pop3_auth => { 
    :server => 'mail.blavel.com', 
    :user_name => 'blavel@blavel.com', 
    :password => '$kav1nlambie',
    :authentication => :login
  }
}


