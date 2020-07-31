$(document).on('ready', function () {
  if ($('#map_marker_place_id') && $('#map_marker_dependency').val() == 'own') {
    var autocompleteUrl = $('#map_marker_place_id').data('url');
    map = initMapForOwn();

    var ownLat = parseFloat($('#map_marker_lat').val());
    var ownLng = parseFloat($('#map_marker_lng').val());

    if (ownLat && ownLng) { initMarkerForOwn(map, { lat: ownLat, lng: ownLng }); }

    initSearchDropDown(autocompleteUrl);
  }
});

function initMarkerForOwn(map, position) {
  if (!position) return;

  marker = new google.maps.Marker({
    map: map,
    icon: icon,
    position: position,
    draggable: true,
    animation: google.maps.Animation.DROP,
  });

  google.maps.event.addListener(marker, 'dragend', function (point) {
    if (marker) marker.setMap(null);

    initMarkerForOwn(map, point.latLng);
  });

  $('#map_marker_lat').val(position.lat);
  $('#map_marker_lng').val(position.lng);

  map.setCenter(position);
  map.setZoom(16);
  return marker;
}

function initMapForOwn() {
  var map = new google.maps.Map(document.getElementById('map'), {
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

  google.maps.event.addListener(map, 'click', function (point) {
    if (marker) marker.setMap(null);

    initMarkerForOwn(map, point.latLng);
  });

  return map;
}
