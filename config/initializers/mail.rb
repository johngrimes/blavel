# Email settings
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "localhost",
  :authentication => :plain,
  :user_name => "blavel@blavel.com",
  :password => "2001gattaca"
}
