
$(document).on('page:change', function () {
  $('.find_nearest').on('click', function () {
    markerFilter = [];
    var $this = $(this);

    if (inGetDirections) {
      clearDirections(function () { initNearest($this); });
    } else {
      initNearest($this);
    }

    return false;
  });
});

function initNearest(selector) {
  $.each($('.checkboxes input').serializeArray(), function (_ind, val) { markerFilter.push(val.name); });

  if (!selector.hasClass('disabled')) {
    selector.addClass('disabled');

    if (!currentUserPosition) {
      getUserCurrentLocation(function (geo) {
        hideInfoPanel();
        currentUserPosition = { lat: geo.coords.latitude, lng: geo.coords.longitude };

        initMarkersByNearestUserPosition(currentUserPosition);
      });
    } else {
      initMarkersByNearestUserPosition(currentUserPosition);
    }
  }
}

function getNearest(coords, callback) {
  if (coords) {
    $.ajax({
      type: 'get',
      dataType: 'json',
      data: { lat: coords.lat, lng: coords.lng, filter: markerFilter },
      url: $currentScript.data('nearest-path'),
      success: function (resp) { callback(resp); },

      error: function () {
        alert('Unexpected error of loading data! Please, try again or refresh page.');
      },
    });
  }
}

function initMarkersByNearestUserPosition(coords, callback) {
  getNearest(coords, function (returnedMarkers) {
    if (returnedMarkers.length == 0) {
      disableBounceOfSelectedMarker();
      hideInfoPanel();
    }

    if (returnedMarkers.length) {
      initMarkersStack(returnedMarkers, function () { $('.find_nearest').removeClass('disabled'); }, true);
    }
  });
}
