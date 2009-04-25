class Message < ActiveRecord::Base
  belongs_to :sender,
    :class_name => 'User',
    :foreign_key => 'sender_id'
  belongs_to :recipient,
    :class_name => 'User',
    :foreign_key => 'recipient_id'

  validates_presence_of :sender, :recipient

  after_create :send_notification_email

  def send_notification_email
    UserMailer.deliver_message(self)
    AdminMailer.deliver_message(self)
  end
end
