var geocoder;
var travelMode;
var directionsDisplay = new google.maps.DirectionsRenderer({ suppressMarkers: true });
var directionsService = new google.maps.DirectionsService;
var addressWasChanged = false;
var inGetDirections = false;

$(document).on('page:change', function () {
  /*
   * Open get direction panel
   */
  $('.get_direction_button, .direction_tab div').on('click', function () {
    inGetDirections = true;

    switch ($(this).data('travel-mode')) {
      case 'WALKING':
        travelMode = google.maps.TravelMode.WALKING;
        break;
      case 'TRANSIT':
        travelMode = google.maps.TravelMode.TRANSIT;
        break;
      case 'DRIVING':
        travelMode = google.maps.TravelMode.DRIVING;
        break;
      default:
        travelMode = google.maps.TravelMode.WALKING;
        break;
    }

    loadedMarkers = {};
    directionsDisplay.setMap(null);

    buildDirection(currentUserPosition);
  });

  /*
   * Address autocomplete
   */
  var typingTimer;
  var doneTypingInterval = 600;

  $('.current_address').on('click', function () { $(this).select(); });

  $('.current_address').on('keydown', function () { clearTimeout(typingTimer); });

  $('.current_address').on('keyup', function () {
    var $this = $(this);
    var $autocomplete = $this.parent().find('.autocomplete');

    clearTimeout(typingTimer);

    typingTimer = setTimeout(function () {
      if ($this.val().length < 3) return false;

      $.ajax({
        type: 'get',
        dataType: 'json',
        data: { query: $this.val() },
        url: $currentScript.data('address-autocomplete-path'),
        success: function (response) {
          if (response.status == 'OK') {
            $autocomplete.hide().html('');

            $.each(response.results, function (_inx, address) {
              $('<li>', {
                text: address.formatted_address, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
                'data-lat': address.geometry.location.lat,
                'data-lng': address.geometry.location.lng,
              }).appendTo($autocomplete);
            });

            $autocomplete.fadeIn('fast');
          }
        },
      });
    }, doneTypingInterval);
  });

  /*
   * Address autocomplete
   */
  $(document).on('click', '.autocomplete li', function () {
    addressWasChanged = true;
    $(addLoader);

    selectedMarker.setMap(null);

    $('.current_address').val($(this).html());
    $('.autocomplete').hide();

    buildDirection({ lat: $(this).data('lat'), lng: $(this).data('lng'), });
  });

  /*
   * Close get direction panel
   */
  $('.get_direction .get_diraction__close').on('click', function () {
    clearDirections();
  });
});

function clearDirections(callback) {
  zoom         = map.zoom;
  mapCanter    = map.center;
  markerFilter = [];

  directionsDisplay.setMap(null);
  inGetDirections   = false;
  addressWasChanged = false;
  hideInfoPanel();

  $('.get_direction').hide();
  $('.current_address').val('');

  if (typeof callback === 'function')
    map = initMap(null, callback);
  else
    map = initMap();
}

function initDirectionMap() {
  $(addLoader);

  $('.direction_tab div').removeClass('active');
  $('.direction_tab div:first').addClass('active');

  return initMap(function (map) {
    google.maps.event.addDomListener(window, 'resize', function () {
      google.maps.event.trigger(map, 'resize');
    });
  });
}

function calculateAndDisplayRoute(userCoords, directionsService, directionsDisplay) {
  google.maps.event.clearListeners(selectedMarker, 'click');

  directionsService.route({
    origin: { lat: userCoords.lat, lng: userCoords.lng },
    destination: selectedMarker.position,
    travelMode: travelMode,
    optimizeWaypoints: true,
    provideRouteAlternatives: true,
  }, function (response, status) {
    if (status === google.maps.DirectionsStatus.OK) {

      directionsDisplay.setDirections(response);
      initUserMarker({ lat: userCoords.lat, lng: userCoords.lng });
      selectedMarker.setMap(map);

      setTimeout(function () {
        if (!addressWasChanged) {
          $('.current_address').fadeOut('middle', function () {
            $(this).val($('.adp-placemark:first .adp-text').html()).fadeIn('middle');
          });
        }

        if ($('.target_address').html() != $('.adp-placemark:last .adp-text').html()) {
          $('.target_address').fadeOut('middle', function () {
            $(this).html($('.adp-placemark:last .adp-text').html()).fadeIn('middle');
          });
        }
      }, 2500);

      $(removeLoader);

    } else {
      alert('It is impossible to build a direction!');
      $('.direction_tab div[data-travel-mode="WALKING"]').trigger('click');
      $(removeLoader);
    }
  });
}

function buildDirection(coords) {
  directionsDisplay.setMap(null);
  map = initDirectionMap();

  directionsDisplay.setMap(map);
  document.getElementById('panel-of-road-path').innerHTML = '';
  directionsDisplay.setPanel(document.getElementById('panel-of-road-path'));

  $('.info_panel .fade_container').fadeOut('middle', function () {
    $('.get_direction').fadeIn('middle', function () {
      $('.target_address').fadeOut('middle', function () {
        $(this).html(selectedMarker.get('address')).fadeIn('middle');
      });
    });
  });

  if (coords) {
    calculateAndDisplayRoute(coords, directionsService, directionsDisplay);
  } else {
    getUserCurrentLocation(function (geo) {
      currentUserPosition = { lat: geo.coords.latitude, lng: geo.coords.longitude };
      calculateAndDisplayRoute(currentUserPosition, directionsService, directionsDisplay);
    });
  }
}

function initUserMarker(position) {
  return new google.maps.Marker({
    map: map,
    icon: markerIcons.user,
    position: position,
  });
}
