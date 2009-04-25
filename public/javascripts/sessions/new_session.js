$(document).ready(focusFirstInput);

function validateLoginForm() {
	
  hideAllFormAlerts("login-form");
	
  var usernameInput = document.getElementById('username');
  var passwordInput = document.getElementById('password');
	
  var username = usernameInput.value;
  var password = passwordInput.value;
	
  if (username.length == 0) {
    showFormAlert('alert-user-name-empty');
    usernameInput.focus();
    return false;
  }
  else if (password.length == 0) {
    showFormAlert('alert-password-empty');
    passwordInput.focus();
    return false;
  }
  else return true;

}