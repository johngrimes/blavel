window.addEvent('load', function() {
  if (Browser.Plugins.Flash.version < 9) {
    showFormAlert('alert-no-flash');
    $('add-files-button').disabled = true;
    $('clear-files-button').disabled = true;
    $('upload-button').disabled = true;
  }

  var ugly = $('ugly').get('html');
  var goblin = $('goblin').get('html');
  var uploader = new FancyUpload2($('upload-container'), $('upload-list'), {
    'url': $('upload-pictures-form').action + '?ugly=' + ugly + '&goblin=' + goblin,
    'fieldName': 'picture',
    'path': '/javascripts/fancyupload/Swiff.Uploader.swf',
    debug: true,
    target: 'add-files-button',
    'onAllSelect': function() {
      /* Show clear and upload buttons */
      $('clear-files-button').setStyle('display', 'inline');
      $('upload-button').setStyle('display', 'inline');
    },
    'onAllComplete': function() {
      /* Redirect to edit pictures page */
      redirectUrl = $('edit-path').get('html');
      window.location = redirectUrl;
    }
  });

  /* Add file type filter */
  filter = {'Images (*.jpg, *.jpeg)': '*.jpg; *.jpeg; *.JPG; *.JPEG'};
  uploader.options.typeFilter = filter;

  $('add-files-button').addEvent('click', function() {
    uploader.browse();
    return false;
  });

  $('clear-files-button').addEvent('click', function() {
    uploader.removeFile();
    uploader.pressResetButton();
    $('clear-files-button').setStyle('display', 'none');
    $('upload-button').setStyle('display', 'none');
    /* Reenable buttons */
    $('add-files-button').disabled = false;
    $('clear-files-button').disabled = false;
    $('upload-button').disabled = false;
    $$('.file-remove').setStyle('display', 'block');
    return false;
  });

  $('upload-button').addEvent('click', function() {
    uploader.upload();
    $('add-files-button').disabled = true;
    $('clear-files-button').disabled = true;
    $('upload-button').disabled = true;
    $$('.file-remove').setStyle('display', 'none');
    return false;
  });

});
