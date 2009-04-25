function validateNoteForm() {
	
  hideAllFormAlerts("note-form");
	
  var contentInput = document.getElementById('content');
  var content = contentInput.value;
  	
  if (content.length == 0) {
    showFormAlert('alert-note-empty');
    contentInput.focus();
    return false;
  }
  else return true;

}