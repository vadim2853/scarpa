//= require spree/backend/map_markers/for_google
//= require spree/backend/map_markers/for_own

var map;
var marker;
var arrScripts = document.getElementsByTagName('script');
var $currentScript = $(arrScripts[arrScripts.length - 1]);
var icon = $currentScript.data('icon');

$(document).on('ready', function () {
  // Marker details switcher
  $('#map_marker_dependency').on('change', function () {
    $('.i18n-tabs, .rating_box, .image_box').slideToggle();
    $(
      'fieldset[data-hook="update_map_marker"] input[type="hidden"], '
      + 'fieldset[data-hook="update_map_marker"] input[type="text"]'
    ).val('');
    for (instance in CKEDITOR.instances) { CKEDITOR.instances[instance].setData(''); }

    if (marker) marker.setMap(null);

    if ($(this).val() == 'google') {
      initSearchDropDown($('#map_marker_place_id').data('url'));

      map = initMapForGoogle();
    } else {
      map = initMapForOwn();
    }
  });
});
