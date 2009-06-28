# Email settings
ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "blavel.com",
  :authentication => :plain,
  :user_name => "blavel@blavel.com",
  :password => "2001gattaca"
}
