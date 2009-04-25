jQuery.ajaxSetup({
  'beforeSend': function(xhr) { xhr.setRequestHeader('Accept', 'text/javascript') }
});

$(document).ready(function() {
  $('#for_who').change(function() {
    $('.feed-items').fadeOut('slow');
    $('#for_who').after('&#160;<img id="feed-loading" src="/images/ajax-loader-sm.gif"/>');
    if ($(this).val() == '1') {
      $('#feed-link').fadeIn('slow');
      $.get($('#for-who-form').attr('action'), null, null, 'script');
    } else {
      $('#feed-link').fadeOut('slow');
      $.get($('#for-who-form').attr('action') + 'feed/everybody', null, null, 'script');
    }
  });
});