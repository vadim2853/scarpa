var countsOfErrorAlerts = {};

function getUserCurrentLocation(callback) {
  $(addLoader);

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(callback, errorListener, {
      enableHighAccuracy: true,
      maximumAge: 0,
      timeout: 10 * 1000 * 1000,
    });
  } else {
    $(removeLoader);
  }
}

function errorListener(data) {
  $(removeLoader);

  switch (data.code) {
    case 0:
      if (!countsOfErrorAlerts.undefined) {
        alert('Something went wrong! Please, refresh page and try again.');
        countsOfErrorAlerts.undefined = 1;
      }

      break;
    case 1:
      if (!countsOfErrorAlerts.isNotAvailable) {
        alert('GPS module is not available, please, check your settings!');
        countsOfErrorAlerts.isNotAvailable = 1;
      }

      break;
    case 2:
      if (!countsOfErrorAlerts.determined) {
        alert('The location of the device could not be determined.');
        countsOfErrorAlerts.determined = 1;
      }

      break;
  }
}

function panToUserLocation(coords) {
  $(removeLoader);

  if (coords) {
    map.panTo({ lat: coords.lat, lng: coords.lng });
    map.setZoom(16);
  }
}
