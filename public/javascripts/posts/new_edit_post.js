changesMade = false;

$(document).ready(function() {
  focusFirstInput();
  refreshMap();
  limitFieldLength('#post_title', 255);
  $('input, textarea').bind('change', function() { changesMade = true; });
  $('.tabs a, .actions a').bind('click', confirmLeavePage);
});

function confirmLeavePage() {
  if (changesMade) {
    if (confirm('Leaving the page before clicking the save! button will cause you to lose any unsaved changes to your post.\nAre you sure you want to do this?')) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

function handleEditorChange() {
  changesMade = true;
}

function handleLocationSelect(event, args) {

  /* Get data from autocomplete selection */
  var data = args[2];
  var displayString = data[0];
  if (data[1].length > 0)
    displayString += ', ' + data[1];
  var locationId = data[3];
  var latitude = data[4];
  var longitude = data[5];

  /* Add new geotag to page */
  var geotag = '<div class="geotag" id="geotag' + locationId + '">' + displayString;
  geotag += '<a onclick="removeGeotag(' + locationId + ');">remove</a>'
  geotag += '<div class="location-id">' + locationId + '</div>';
  geotag += '<div class="latitude">' + latitude + '</div>';
  geotag += '<div class="longitude">' + longitude + '</div>';
  geotag += '</div>';
  $('#geotags').append(geotag);

  /* Add new hidden location field to page */
  $('#geotags').append('<input id="post[location_ids][]" name="post[location_ids][]" type="hidden" value="' + locationId +'" />');

  /* Refresh Google map image */
  refreshMap();

  /* Empty location selector ready for next selection */
  $('#location-input').val('');

  /* Get ready for next location input */
  document.getElementById('location-input').focus();
}

function handleLocationChange() {}

function refreshMap() {
  $('#map').empty();
  $('#map').parent().hide();
  var geotags = $('.geotag');
  if (geotags.length > 0) {
    var markers = 'markers=';
    var locationIds = '';
    for (var i = 0; i < geotags.length; i++) {
      var locationId = $(geotags[i]).children('.location-id').html();
      var latitude = $(geotags[i]).children('.latitude').html();
      var longitude = $(geotags[i]).children('.longitude').html();
      markers += latitude + ',' + longitude + ',midred|';
      locationIds += locationId + ',';
      var center = 'center=' + latitude + ',' + longitude;
    }
    markers = markers.substring(0, markers.length - 1);
    locationIds = locationIds.substring(0, locationIds.length - 1);
    url = 'http://maps.google.com/staticmap?' + markers + '&size=200x200&key=ABQIAAAAz9BSUSsddozkEVwiYwtw3RTYEx-d63aBcVxkugofEUZdqQuoiBRXl569USSfQGZTmkdvvg-ClP2ELA';
    if (geotags.length < 2) {
      url += '&' + center + '&zoom=10';
    }
    $('#map').append('<a id="map-link" href="javascript:void(0);"><img src="' + url + '" width="200" height="200" alt="Map of tagged locations!"/></a>');

    $('#map-link').bind('click', function() {
      Shadowbox.open({
        player: 'iframe',
        content: '/map/' + locationIds
      });
    });

    $('#map').parent().show();
  }
}

function removeGeotag(number) {

  /* Remove geotag from page */
  $('#geotag' + number).remove();

  /* Remove hidden location field */
  $("input[type='hidden'][value='" + number + "']").remove();

  /* Refresh Google map image */
  refreshMap();

}
