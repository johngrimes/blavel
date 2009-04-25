$(document).ready(function() {
  focusFirstInput();
  limitFieldLength('#user_login', 40);
  limitFieldLength('#user_password', 40);
  limitFieldLength('#user_email', 100);
});

function validateJoinForm() {

  hideAllFormAlerts("join-form");

  var username = document.getElementById('user_login').value;
  var password = document.getElementById('user_password').value;
  var confirmPassword = document.getElementById('user_password_confirmation').value;
  var emailAddress = document.getElementById('user_email').value;
  var captchaResponse = document.getElementById('recaptcha_response_field').value;

  var usernameInput = document.getElementById('user_login');
  var passwordInput = document.getElementById('user_password');
  var confirmPasswordInput = document.getElementById('user_password_confirmation');
  var emailAddressInput = document.getElementById('user_email');
  var captchaResponseInput = document.getElementById('recaptcha_response_field');

  nonAlnumRE = new RegExp(/^\w+$/);
  reservedLoginsRE = new RegExp(/^browse$|^posts$|^pictures$|^notes$|^join$|^locations$|^facebook$|^home$|^login$|^logout$|^opencode$|^messages$|^activate$|^feed$/);
  emailFormatRE = new RegExp(/^.*@.*$/);

  if (username.length == 0) {
    showFormAlert('alert-login-empty');
    usernameInput.focus();
    return false;
  }
  else if (username.length >= 40) {
    showFormAlert('alert-login-too-long');
    usernameInput.select();
    return false;
  }
  else if (!nonAlnumRE.test(username)) {
    showFormAlert('alert-login-bad-characters');
    usernameInput.select();
    return false;
  }
  else if (reservedLoginsRE.test(username)) {
    showFormAlert('alert-login-reserved');
    usernameInput.select();
    return false;
  }
  else if (password.length == 0) {
    showFormAlert('alert-password-empty');
    passwordInput.focus();
    return false;
  }
  else if (password.length < 8) {
    showFormAlert('alert-password-too-short');
    passwordInput.select();
    return false;
  }
  else if (password.length >= 40) {
    showFormAlert('alert-password-too-long');
    passwordInput.focus();
    return false;
  }
  else if (confirmPassword.length == 0) {
    showFormAlert('alert-password-confirmation-empty');
    confirmPasswordInput.focus();
    return false;
  }
  else if (confirmPassword != password) {
    showFormAlert('alert-password-confirmation-different');
    confirmPasswordInput.select();
    return false;
  }
  else if (emailAddress.length == 0) {
    showFormAlert('alert-email-empty');
    emailAddressInput.focus();
    return false;
  }
  else if (emailAddress.length > 100) {
    showFormAlert('alert-email-too-long');
    emailAddressInput.select();
    return false;
  }
  else if (!emailFormatRE.test(emailAddress)) {
    showFormAlert('alert-email-wrong-format');
    emailAddressInput.select();
    return false;
  }
  else if (captchaResponse.length == 0) {
    showFormAlert('alert-captcha-empty');
    captchaResponseInput.select();
    return false;
  }
  else return true;
}
