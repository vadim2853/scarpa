$(document).on('ready', function () {
  var autocompleteUrl = $('#map_marker_place_id').data('url');

  if (autocompleteUrl && $('#map_marker_dependency').val() == 'google') {
    map = initMapForGoogle();

    initSearchDropDown(autocompleteUrl);
  }
});

// jscs:disable requireCamelCaseOrUpperCaseIdentifiers
function initSearchDropDown(autocompleteUrl) {
  $('#map_marker_place_id').select2({
    id: function (obj) { return obj.place_id; },

    minimumInputLength: 5,
    ajax: {
      type: 'get',
      dataType: 'json',
      triggerChange: true,
      quietMillis: 2000,
      url: autocompleteUrl,
      cache: true,
      data: function (query) { return { query: query }; },

      results: function (data) { return { results: data.results }; },
    },
    initSelection: function (element, callback) {
      if ($(element).val()) {
        callback({
          place_id: $(element).val(),
          name: $('#map_marker_name').val(),
          formatted_address: $('#map_marker_address').val(),
        });

        var lat = parseFloat($('#map_marker_lat').val());
        var lng = parseFloat($('#map_marker_lng').val());

        if (lat && lng) { marker = initMarkerForGoogle(map, { lat: lat, lng: lng }); }
      }
    },

    formatResult: placeFormat,
    formatSelection: placeFormat,
  }).on('change', function (e) {
    if (marker) marker.setMap(null);
    marker = initMarkerForGoogle(map, e.added.geometry.location);

    $('#map_marker_name').val(e.added.name);
    $('#map_marker_address').val(e.added.formatted_address);
  });
}

function placeFormat(e) {
  return '<span class="place_option">' + e.name + ' (' + e.formatted_address + ')' + '</span>';
}

function initMarkerForGoogle(map, position) {
  if (!position) return;

  marker = new google.maps.Marker({
    map: map,
    icon: icon,
    position: position,
    draggable: true,
    animation: google.maps.Animation.DROP,
  });

  $('#map_marker_lat').val(position.lat);
  $('#map_marker_lng').val(position.lng);

  map.setCenter(position);
  map.setZoom(18);
  return marker;
}

function initMapForGoogle() {
  return new google.maps.Map(document.getElementById('map'), {
    disableDefaultUI: true,
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT,
    },
    rotateControl: true,
    scrollwheel: false,
    center: { lat: 42.150047, lng: 13.360582 },
    zoom: 6,
  });
}
