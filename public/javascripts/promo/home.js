$(document).ready(function() {
  $('#join-button').mouseover(function() {
    $(this).attr('src', '/images/promo/join-button-highlight.png');
  });
  $('#join-button').mouseout(function() {
    $(this).attr('src', '/images/promo/join-button.png');
  });
});