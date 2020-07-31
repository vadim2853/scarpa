var loadedMarkers = {};

function getMarkersByMapBounds(map, callback) {
  var bounds   = map.getBounds();
  var NECorner = bounds.getNorthEast();
  var SWCorner = bounds.getSouthWest();

  $.ajax({
    type: 'get',
    dataType: 'json',
    url: $currentScript.data('places-path'),
    data: {
      polygon: NECorner.lat() + ' ' + NECorner.lng() + ',' + NECorner.lat() + ' ' + SWCorner.lng() + ','
             + SWCorner.lat() + ' ' + SWCorner.lng() + ',' + SWCorner.lat() + ' ' + NECorner.lng() + ','
             + NECorner.lat() + ' ' + NECorner.lng(),
      filter: markerFilter,
    },

    success: function (resp) { callback(resp); },

    error: function () {
      callback([]);
      alert('Error occurred when I want get markers');
    },
  });
}

function initMarkersByMapBounds(map) {
  getMarkersByMapBounds(map, function (returnedMarkers) {
    if (returnedMarkers.length) initMarkersStack(returnedMarkers);
  });
}

/*
 * Nearest marker index == 0 -> ordered by server
*/
function initMarkersStack(returnedMarkers, callback, activateNearestMarker) {
  var tmpList = {};

  $.each(returnedMarkers, function (_inx, item) {
    if (loadedMarkers[item.id]) {
      tmpList[item.id] = loadedMarkers[item.id];

      if (activateNearestMarker && _inx == 0) { setOrActivateMarkerBehaviors(tmpList[item.id]); }

      delete loadedMarkers[item.id];
      return;
    }

    var marker = new google.maps.Marker({
      id: item.id,
      map: map,
      animation: google.maps.Animation.DROP,
      icon: markerIcons[item.marker_type], // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
      position: { lat: item.lat, lng: item.lng },
    });

    marker.setValues({
      markerType: item.marker_type, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
      placeid: item.place_id, // jscs:ignore requireCamelCaseOrUpperCaseIdentifiers
      address: item.address,
    });

    if (activateNearestMarker && _inx == 0) {
      setOrActivateMarkerBehaviors(marker);
    } else if (selectedMarker && marker.get('placeid') == selectedMarker.get('placeid')) {
      setOrActivateMarkerBehaviors(marker, true);
    }

    google.maps.event.addListener(marker, 'click', function () {
      var _this = this;
      setOrActivateMarkerBehaviors(_this);
    });

    tmpList[item.id] = marker;
  });

  if (loadedMarkers) { $.each(loadedMarkers, function (_inx, marker) { marker.setMap(null); }); }

  loadedMarkers = tmpList;
  tmpList = {};

  typeof callback === 'function' && callback();
}

function setOrActivateMarkerBehaviors(marker, withoutPanToCenter) {
  disableBounceOfSelectedMarker();
  selectedMarker = marker;
  setTimeout(function () { enableBounceOfSelectedMarker(); }, 500);

  if (!withoutPanToCenter) map.panTo(selectedMarker.get('position'));

  showInfoPanel(selectedMarker);
}

function activateMarkerOfMainOffice() {
  $.each(loadedMarkers, function (_inx, marker) {
    if (marker.get('placeid') && marker.get('placeid') == $currentScript.data('main-office-placeid')) {
      setOrActivateMarkerBehaviors(marker);
      return false;
    }
  });
}
