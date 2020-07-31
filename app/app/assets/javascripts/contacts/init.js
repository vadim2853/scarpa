//= require contacts/theme
//= require contacts/get_direction
//= require contacts/find_nearest
//= require contacts/places
//= require contacts/place_details
//= require contacts/user_location

var arrScripts = document.getElementsByTagName('script');
var $currentScript = $(arrScripts[arrScripts.length - 1]);
var map;
var markerIcons = { // jscs:disable requireCamelCaseOrUpperCaseIdentifiers
  m_office: $currentScript.data('office-icon'),
  m_club: $currentScript.data('club-icon'),
  m_store: $currentScript.data('store-icon'),
  m_restaurant: $currentScript.data('restaurant-icon'),
  user: $currentScript.data('user-icon'),
}; // jscs:enable requireCamelCaseOrUpperCaseIdentifiers
var markerFilter;
var currentUserPosition;
var zoom = 10;
var mapCanter = { lat: 44.771188, lng: 8.350812 };

function initMap(listeners, callback) {
  $(addLoader);

  var map = new google.maps.Map(document.getElementById('map'), {
    disableDefaultUI: true,
    zoomControl: true,
    zoomControlOptions: {
      position: google.maps.ControlPosition.TOP_RIGHT,
    },
    rotateControl: true,
    scrollwheel: false,
    center: mapCanter,
    zoom: zoom,
  });

  /** Setup theme */
  map.set('styles', scarpaTheme);

  typeof listeners === 'function' ? listeners(map) : mainListeners(map);
  typeof callback === 'function' && callback(map);

  return map;
}

function mainListeners(map) {
  google.maps.event.addListener(map, 'click', function () {
    hideInfoPanel();
    disableBounceOfSelectedMarker();
  });

  google.maps.event.addListener(map, 'dragend', function () {
    initMarkersByMapBounds(map);
  });

  google.maps.event.addListener(map, 'projection_changed', function () {
    initMarkersByMapBounds(map);
  });

  google.maps.event.addListener(map, 'zoom_changed', function () {
    initMarkersByMapBounds(map);
  });

  google.maps.event.addDomListener(window, 'resize', function () {
    google.maps.event.trigger(map, 'resize');
  });

  google.maps.event.addListenerOnce(map, 'tilesloaded', function () {
    getUserCurrentLocation(function (geo) {
      currentUserPosition = { lat: geo.coords.latitude, lng: geo.coords.longitude };
    });

    activateMarkerOfMainOffice();
    $(removeLoader);
  });
}

/*
 * =================================
 * ++++++ Initialization part ++++++
 * =================================
 */
$(document).on('page:change', function () {
  map = initMap();

  $('.time_box .clock').on('click', function () {
    if ($('.time_box .time').html()) {
      $('.time_box .time').slideToggle('fast', function () {
        google.maps.event.trigger(map, 'resize');
      });
    }
  });

  $('.direction_tab').on('click', 'div:not(.active)', function () {
    $(this)
      .addClass('active').siblings().removeClass('active')
      .closest('div.tabs').find('div.direction_tab_description')
      .removeClass('active').eq($(this).index()).addClass('active');
  });
});
