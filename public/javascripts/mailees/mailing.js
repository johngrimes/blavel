$(document).ready(function() {
  focusFirstInput();
  limitFieldLength('#add-mailee-field', 255);
  $('#add-form').submit(validateAddForm);
});

function addMailee() {
  $('#add_mailee').val($('#add-mailee-field').val());
  $('#add-form').submit();
}

function removeMailee(value) {
  $('#remove_mailee').val(value);
  $('#remove-form').submit();
}

function toggleSelectAll() {
  $('.mailee-check-box').each(function() {
    if (this.checked == false) {
      this.checked = true;
    } else {
      this.checked = false;
    }
  });
}

function validateAddForm() {

  hideAllFormAlerts("send-form");

  var email = document.getElementById('add-mailee-field').value;
  var emailInput = document.getElementById('add-mailee-field');

  emailFormatRE = new RegExp(/.*@.*/);

  if (email.length == 0) {
    showFormAlert('alert-field-empty');
    emailInput.focus();
    return false;
  }
  else if (!emailFormatRE.test(email)) {
    showFormAlert('alert-wrong-format');
    emailInput.select();
    return false;
  }
  else if ($('.mailee').text().toLowerCase().search(email.toLowerCase()) != -1) {
    showFormAlert('alert-mailee-exists');
    emailInput.select();
    return false;
  }
  else return true;
}
