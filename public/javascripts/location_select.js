$(document).ready(function() {

  $('.yui-ac').each(function() {
    
    var datasource = new YAHOO.widget.DS_XHR("/locations/search", ["Location", "Name", "CountryName", "Type", "Id", "Latitude", "Longitude"]); 
    datasource.responseType = YAHOO.widget.DS_XHR.TYPE_XML; 
    datasource.queryMatchContains = true; 
    datasource.scriptQueryParam = "query";
          
    var input = $(this).children('.yui-ac-input')[0];
    var container = $(this).children('.yui-ac-container')[0];
    var locationSelector = new YAHOO.widget.AutoComplete($(input).attr('id'), $(container).attr('id'), datasource);
    locationSelector.maxResultsDisplayed = 15;
    locationSelector.useShadow = true;
    locationSelector.autoHighlight = false;
    locationSelector.setFooter('<div class="ac-footer">Hint: Geotagging your post allows it to be shown on maps.</div>');

    locationSelector.itemSelectEvent.subscribe(handleLocationSelect);
    locationSelector.textboxKeyEvent.subscribe(handleLocationChange);

    locationSelector.formatResult = function(resultItem, query) {
      var formattedResult = '<table class="place-list-item"><tbody><tr><td class="place-name">' + resultItem[0];
      if (resultItem[1].length > 0)
        formattedResult += ', ' + resultItem[1];
      formattedResult += '</td>';
      formattedResult += '<td class="place-type">' + resultItem[2] + '</td></tr></tbody></table>';

      return formattedResult;
    }
          
  });
	
});