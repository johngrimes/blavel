class MessagesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  layout 'standard', :only => [ :new, :show, :manage ]
  before_filter :login_required

  # Responds with a form to send a new private message to the specified user.
  # Parameters:: user_login
  # Route:: GET /messages/new/:user_login
  def new

    # Pass through specified user as recipient, making sure it exists
    if !@recipient = User.find_by_login(params[:user_login])
      raise ActiveRecord::RecordNotFound
    end

    # Pass through a new message with the specified recipient
    @message = Message.new
    @message.sender = current_user
    @message.recipient = @recipient
  end

  # Creates a new message from the current user to the specified user.
  # Parameters:: message[recipient_id, content]
  # Route:: POST /messages
  def create

    # Create new message and populate it with sent data
    @message = Message.new(params[:message])

    # If message recipient is current user, abort and redirect back to manage
    # action with an error message
    if @message.recipient == current_user
      flash[:error] = "You can't send a message to yourself, you nonger!"
      redirect_to :action => 'manage'
    else

      # Set sender to current user, regardless of what user may have sent through
      # in the sender_id field
      @message.sender = current_user

      # Strip all tags out of message content
      @message.content = sanitize(@message.content, :tags => %w())

      # Save new message and redirect to manage action
      if result = @message.save!
        flash[:notice] = "Your message was sent to #{@message.recipient.login}."
        redirect_to :action => 'show', :id => @message.id
      end
    end
  end

  # Displays the specified message.
  # Parameters:: id
  # Route:: GET /messages/:id
  def show

    # Pass through the specified message, making sure it exists
    @message = Message.find(params[:id])

    # Check that the current user is either the sender or recipient of the
    # message
    if !(current_user == @message.sender) && !(current_user == @message.recipient)
      flash[:error] = "The message you requested is private and does not have you listed as a sender or recipient."
      redirect_to :action => 'manage'
    else

      # Pass through all sent and received messages, sorted in reverse
      # chronological order
      @messages = messages_sent_and_received(current_user)

      # Render the same template as the manage action
      render :action => 'manage'
    end
  end

  # Responds with an interface to browse all messages sent to or sent by the
  # current user.
  # Route:: GET /messages
  def manage

    # Pass through all sent and received messages, sorted in reverse
    # chronological order
    @messages = messages_sent_and_received(current_user)
  end

  # Responds with JavaScript that loads a HTML fragment showing the specified
  # message, along with all other messages that have been sent between the
  # current user and the other party to the message.
  # Parameters:: id
  # Route:: POST /messages/:id/convo
  def convo

    # Pass through the specified message, making sure it exists
    @message = Message.find(params[:id])

    # Render javascript template
    respond_to do |format|
      format.js { render :template => 'messages/convo.js.erb' }
    end
  end

  # Marks the specified message as read, and responds with a HTML fragment
  # representing a list of all messages sent to or sent by the current user.
  # Parameters:: id
  # Route:: POST /messages/read
  def mark_as_read

    # Get the specified message, making sure it exists
    @message = Message.find(params[:id])

    # Check that the recipient of the message is the current user
    if @message.recipient == current_user

      # Mark the message as read
      @message.read = true

      # Save the message
      @message.save!
    end

    # Pass through all sent and received messages, sorted in reverse
    # chronological order
    @messages = messages_sent_and_received(current_user)

    # Render javascript template
    respond_to do |format|
      format.js { render :template => 'messages/mark_as_read.js.erb' }
    end
  end

  private

  # Returns an array of all messages sent to or sent by the specified user,
  # sorted in reverse chronological order.
  def messages_sent_and_received(user)

    # Get all messages sent by the specified user
    sent = Message.find_all_by_sender_id(user.id)

    # Get all messages received by the specified user
    received = Message.find_all_by_recipient_id(user.id)

    # Return all sent and received messages, sorted in reverse
    # chronological order
    messages = smush(sent, received)
    messages.sort! { |x,y| y.created_at <=> x.created_at }

    return messages
  end
end
