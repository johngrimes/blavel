$(document).ready(function() {
  Shadowbox.close = reloadPage;
});

function reloadPage() {
  window.location.reload();
}