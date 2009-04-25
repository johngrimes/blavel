jQuery.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript') }
});

$(document).ready(function() {
  addBehaviourToList();
});

function addBehaviourToList() {

  // Highlight rows in list when moused over
  $('#list tr.message').mousemove(function() {
    $(this).addClass('highlighted');
  });
  $('#list tr.message').mouseout(function() {
    $(this).removeClass('highlighted');
  });

  // Add behaviour to click event
  $('#list tr.message').click(handleListRowClick);
}

function handleListRowClick() {

  // Fade out convo container
  $('#convo').fadeOut('slow');

  // Get URL from form within row
  var url = $(this).find('form').attr('action');

  // Send a GET request for the convo javascript fragment
  $.get(url, null, null, 'script');

  // Get message id from id attribute of row
  var id = $(this).attr('id').split('-');
  id = id[id.length - 1];

  // Send a POST request to mark the message as read and return an updated list
  // fragment
  if ($(this).hasClass('unread')) {
    $.post('/messages/read', { id: id }, addBehaviourToList, 'script');
  }
}
