changesMade = false;

$(document).ready(function() {
  focusFirstInput();
  limitFieldLength('input.title', 255);
  limitFieldLength('input.description', 300);
  $('input, textarea').bind('change', function() { changesMade = true; });
  $('.tabs a, .actions a').bind('click', confirmLeavePage);
});

function confirmLeavePage() {
  if (changesMade) {
    if (confirm('Leaving the page before clicking the save changes! button will cause you to lose any unsaved changes to your pictures.\nAre you sure you want to do this?')) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
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

  /* Set hidden form field */
  var container = args[0]._elContainer;
  var split = $(container).attr('id').split('-');
  var pictureId = split[split.length - 1];
  idField = document.getElementById('picture[' + pictureId + '][location]');
  $(idField).val(locationId);

  /* Refresh location map */
  refreshMap(pictureId, locationId, latitude, longitude);

  /* Set input field to full display version of location */
  inputField = document.getElementById('picture[' + pictureId + '][location_input]');
  inputField.value = displayString;

}

function handleLocationChange(event, args) {
  var inputField = args[0]._elTextbox;
  if (inputField.value == '') {
    var pictureEditRow = $(inputField).parents('.picture-edit-row')[0];
    var mapContainer = $(pictureEditRow).find('.map-container')[0];
    var locationField = $(pictureEditRow).find('.location-hidden-field')[0];
    $(mapContainer).hide();
    $(locationField).val('');
  }
}

function refreshMap(pictureId, locationId, latitude, longitude) {
  $('#picture-' + pictureId + '-map').empty();
  $('#picture-' + pictureId + '-map').parent().show();
  url = 'http://maps.google.com/staticmap?center=' + latitude + ',' + longitude + '&zoom=10&markers=' + latitude + ',' + longitude + ',midwhite&size=150x150&key=ABQIAAAAz9BSUSsddozkEVwiYwtw3RTYEx-d63aBcVxkugofEUZdqQuoiBRXl569USSfQGZTmkdvvg-ClP2ELA';
  $('#picture-' + pictureId + '-map').append('<a id="picture-' + pictureId + '-map-link" href="javascript:void(0);"><img src="' + url + '" width="150" height="150" alt="Map of tagged locations!"/></a>');
  $('#picture-' + pictureId + '-map-link').bind('click', function() {
      Shadowbox.open({
        player: 'iframe',
        content: '/map/' + locationId
      });
    });
}

function getMaxSequence() {
  var maxSequence = 1;
  sequenceFields = $('.sequence-hidden-field');
  for (var i = 0; i < sequenceFields.length; i++) {
    var sequence = parseInt($(sequenceFields[i]).val());
    if (sequence > maxSequence) maxSequence = sequence;
  }
  return maxSequence;
}

function moveUp(pictureId) {
  var maxSequence = getMaxSequence();
  var toBeMovedSequenceField = document.getElementById('picture[' + pictureId + '][sequence]');
  var sequence = $(toBeMovedSequenceField).val();
  if (sequence > 1 && sequence <= maxSequence) {
    var toBeReplacedSequenceField = $(".sequence-hidden-field[value='" + (sequence - 1) + "']")[0];
    var toBeMoved = $(toBeMovedSequenceField).parents('.picture-edit-row')[0];
    var toBeMovedActions = $(toBeMoved).next();
    var toBeReplaced = $(toBeReplacedSequenceField).parents('.picture-edit-row')[0];
    $(toBeMovedSequenceField).val(sequence - 1);
    $(toBeReplacedSequenceField).val(sequence);
    $(toBeReplaced).before(toBeMoved);
    $(toBeReplaced).before(toBeMovedActions);
  }
}

function moveDown(pictureId) {
  var maxSequence = getMaxSequence();
  var toBeMovedSequenceField = document.getElementById('picture[' + pictureId + '][sequence]');
  var sequence = $(toBeMovedSequenceField).val();
  if (sequence >= 1 && sequence < maxSequence) {
    var toBeReplacedSequenceField = $(".sequence-hidden-field[value='" + (parseInt(sequence) + 1) + "']")[0];
    var toBeMoved = $(toBeMovedSequenceField).parents('.picture-edit-row')[0];
    var toBeMovedActions = $(toBeMoved).next();
    var toBeReplaced = $(toBeReplacedSequenceField).parents('.picture-edit-row')[0];
    var toBeReplacedActions = $(toBeReplaced).next();
    $(toBeMovedSequenceField).val(parseInt(sequence) + 1);
    $(toBeReplacedSequenceField).val(sequence);
    $(toBeReplacedActions).after(toBeMovedActions);
    $(toBeReplacedActions).after(toBeMoved);
  }
}
